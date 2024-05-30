# Use a multi-stage build to keep the final image size smaller and more secure

# Pull base image
ARG BASE_IMAGE=oraclelinux:7-slim
FROM ${BASE_IMAGE} as base

# Labels
LABEL provider="Oracle" \
      issues="https://github.com/oracle/docker-images/issues" \
      volume.data="/opt/oracle/oradata" \
      volume.setup.location1="/opt/oracle/scripts/setup" \
      volume.setup.location2="/docker-entrypoint-initdb.d/setup" \
      volume.startup.location1="/opt/oracle/scripts/startup" \
      volume.startup.location2="/docker-entrypoint-initdb.d/startup" \
      port.listener="1521" \
      port.oemexpress="5500"

# Arguments for the build
ARG SLIMMING=true
ARG INSTALL_FILE_1="LINUX.X64_193000_db_home.zip"

# Environment variables
ENV ORACLE_BASE=/opt/oracle \
    ORACLE_HOME=/u01/app/oracle/product/19.3.0/dbhome_1 \
    INSTALL_DIR=/opt/install \
    INSTALL_FILE_1=${INSTALL_FILE_1} \
    INSTALL_RSP="db_inst.rsp" \
    CONFIG_RSP="dbca.rsp.tmpl" \
    PWD_FILE="setPassword.sh" \
    RUN_FILE="runOracle.sh" \
    START_FILE="startDB.sh" \
    CREATE_DB_FILE="createDB.sh" \
    CREATE_OBSERVER_FILE="createObserver.sh" \
    SETUP_LINUX_FILE="setupLinuxEnv.sh" \
    CHECK_SPACE_FILE="checkSpace.sh" \
    CHECK_DB_FILE="checkDBStatus.sh" \
    USER_SCRIPTS_FILE="runUserScripts.sh" \
    INSTALL_DB_BINARIES_FILE="installDBBinaries.sh" \
    RELINK_BINARY_FILE="relinkOracleBinary.sh" \
    CONFIG_TCPS_FILE="configTcps.sh" \
    SLIMMING=${SLIMMING} \
    ENABLE_ARCHIVELOG=false \
    ARCHIVELOG_DIR_NAME=archive_logs \
    CLONE_DB=false \
    STANDBY_DB=false \
    PRIMARY_DB_CONN_STR="" \
    DG_OBSERVER_ONLY=false \
    DG_OBSERVER_NAME="" \
    CHECKPOINT_FILE_EXTN=".created" \
    WALLET_DIR="" \
    PATH=${ORACLE_HOME}/bin:${ORACLE_HOME}/OPatch/:/usr/sbin:$PATH \
    LD_LIBRARY_PATH=${ORACLE_HOME}/lib:/usr/lib \
    CLASSPATH=${ORACLE_HOME}/jlib:${ORACLE_HOME}/rdbms/jlib

# Create the oracle group and user
RUN groupadd oracle && \
    useradd -m -g oracle -d /home/oracle -s /bin/bash oracle && \
    echo "oracle:oracle" | chpasswd
# Run group creation commands
RUN groupadd --gid 54321 oinstall && \
    groupadd --gid 54322 dba && \
    groupadd --gid 54323 asmdba && \
    groupadd --gid 54324 asmoper && \
    groupadd --gid 54325 asmadmin && \
    groupadd --gid 54326 oper && \
    groupadd --gid 54327 backupdba && \
    groupadd --gid 54328 dgdba && \
    groupadd --gid 54329 kmdba

# Add oracle user to additional groups
RUN usermod -a -G dba,oinstall,asmdba,asmoper,asmadmin,oper,backupdba,dgdba,kmdba oracle


# Add security limits configurations
RUN echo "oracle soft nofile 1024\n\
oracle hard nofile 65536\n\
oracle soft nproc 16384\n\
oracle hard nproc 16384\n\
oracle soft stack 10240\n\
oracle hard stack 32768\n\
oracle hard memlock 134217728\n\
oracle soft memlock 134217728" > /etc/security/limits.d/oracle-database-preinstall-19c.conf

# Set SELinux to permissive
#RUN sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config

# Create Oracle directories, set ownership and permissions
RUN mkdir -p /u01/app/oracle/product/19.3.0/dbhome_1 && \
    mkdir -p /u02/oradata && \
    chown -R oracle:oinstall /u01 /u02 && \
    chmod -R 775 /u01 /u02

# Create scripts directory and set environment variables
RUN mkdir /home/oracle/scripts && \
    echo '# ORACLE SETTINGS' > /home/oracle/scripts/setEnv.sh && \
    echo 'export TMP=/tmp' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export TMPDIR=$TMP' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export ORACLE_HOSTNAME=DENBG0156VM' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export ORACLE_UNQNAME=ORCL' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export ORACLE_BASE=/u01/app/oracle' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export ORACLE_HOME=$ORACLE_BASE/product/19.3.0/dbhome_1' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export ORA_INVENTORY=/u01/app/oraInventory' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export ORACLE_SID=tc' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export PDB_NAME=PDB1' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export DATA_DIR=/u02/oradata' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export PATH=/usr/sbin:/usr/local/bin:$PATH' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib' >> /home/oracle/scripts/setEnv.sh && \
    echo 'export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib' >> /home/oracle/scripts/setEnv.sh && \
    echo ". /home/oracle/scripts/setEnv.sh" >> /home/oracle/.bash_profile && \
    chown -R oracle:oinstall /home/oracle/scripts && \
    chmod u+x /home/oracle/scripts/*.sh

# Copy necessary files for installation and runtime
COPY $SETUP_LINUX_FILE $CHECK_SPACE_FILE $INSTALL_DIR/
COPY $RUN_FILE $START_FILE $CREATE_DB_FILE $CREATE_OBSERVER_FILE $CONFIG_RSP $PWD_FILE $CHECK_DB_FILE $USER_SCRIPTS_FILE $RELINK_BINARY_FILE $CONFIG_TCPS_FILE $ORACLE_BASE/

RUN chmod ug+x $INSTALL_DIR/*.sh && \
    sync && \
    $INSTALL_DIR/$CHECK_SPACE_FILE && \
    $INSTALL_DIR/$SETUP_LINUX_FILE && \
    rm -rf $INSTALL_DIR

# Copy templates
COPY clone/oracle /u01/app/oracle/product/19.3.0/dbhome_1/assistants/dbca/templates/

# Install the database software binaries in a separate stage
FROM base AS builder

ARG DB_EDITION

# Copy DB install file
COPY --chown=oracle:dba $INSTALL_FILE_1 $INSTALL_RSP $INSTALL_DB_BINARIES_FILE $INSTALL_DIR/

# Install DB software binaries
USER oracle
RUN chmod ug+x "$INSTALL_DIR"/*.sh && \
    sync && \
    "$INSTALL_DIR"/"$INSTALL_DB_BINARIES_FILE" $DB_EDITION

# Create the final runtime image
FROM base

USER oracle
COPY --chown=oracle:dba --from=builder $ORACLE_BASE $ORACLE_BASE

USER root
RUN "$ORACLE_BASE"/oraInventory/orainstRoot.sh && \
    "$ORACLE_HOME"/root.sh

USER oracle
WORKDIR /home/oracle

# Add a bashrc file to capitalize ORACLE_SID in the environment
RUN echo 'ORACLE_SID=${ORACLE_SID:-tc}; export ORACLE_SID=${ORACLE_SID^^}' > .bashrc

# Create a new database
RUN cd $ORACLE_HOME/assistants/dbca && \
    ./dbca -silent -createDatabase -gdbName tc -sid tc -templateName tc_create_user_ilog.sql -sysPassword oracle -datafileDestination /opt/oracle

# Healthcheck to ensure the database is running
HEALTHCHECK --interval=1m --start-period=5m --timeout=30s \
   CMD "$ORACLE_BASE/$CHECK_DB_FILE" >/dev/null || exit 1

# Default command to start Oracle Database
CMD [ "/bin/bash", "-c", "exec $ORACLE_BASE/$RUN_FILE" ]


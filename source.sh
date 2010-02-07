if [ -z "$BASH_SOURCE" ]; then
   CLJENV_HOME="$(cd $(dirname $0)/ && pwd)"
else
   CLJENV_HOME="$(cd $(dirname $BASH_SOURCE)/ && pwd)"
fi

export CLJENV_HOME

USER_CLJENV_PATH="$HOME/.cljenv"
SYSTEM_CLJENV_PATH="/etc/cljenv/system_cljenv"
DEFAULT_CLJENV_PATH="$CLJENV_HOME/default_cljenv"

function _cljenv_first_available_env_name() {
   if [ -f "$USER_CLJENV_PATH" ] ; then
        echo "user"
    elif [ -f "$SYSTEM_CLJENV_PATH" ] ; then
        echo "system"
    else
        echo "default"
    fi
}

function _cljenv_path_for_create() {
    if [ -f "$USER_CLJENV_PATH" ] ; then
        echo $USER_CLJENV_PATH
    elif [ -f "$SYSTEM_CLJENV_PATH" ] ; then
        echo $SYSTEM_CLJENV_PATH
    else
        echo $DEFAULT_CLJENV_PATH
    fi
}

function cljenv_create() {
    if [ -z "$1" ]; then
        TARGET="`pwd`"
    else
        TARGET="$1"
    fi

    if [ -d $TARGET ] ; then
        cp `_cljenv_path_for_create` $TARGET/.cljenv
    else
        echo "ERROR: target $TARGET does not exist"
        exit 1
    fi
}

function cljenv_activate() {

    cljenv_deactivate () {

        unset CLOJURE_JAR
        unset CLOJURE_CONTRIB_JAR
        unset CLOJURE_JAVA_PATH
        unset CLOJURE_CLASSPATH
        unset CLOJURE_VM_ARGS
        unset CLOJURE_NATIVE_LIBRARY_PATH
        unset CLJENV_NAME

        if [ -n "$_OLD_CLJENV_PATH" ] ; then
            PATH="$_OLD_CLJENV_PATH"
            export PATH
            unset _OLD_CLJENV_PATH
        fi

        if [ -n "$_OLD_CLJENV_CLOJURE_JAR" ] ; then
            CLOJURE_JAR="$_OLD_CLJENV_CLOJURE_JAR"
            export CLOJURE_JAR
            unset _OLD_CLJENV_CLOJURE_JAR
        fi

        if [ -n "$_OLD_CLJENV_CLOJURE_CONTRIB_JAR" ] ; then
            CLOJURE_CONTRIB_JAR="$_OLD_CLJENV_CLOJURE_CONTRIB_JAR"
            export CLOJURE_CONTRIB_JAR
            unset _OLD_CLJENV_CLOJURE_CONTRIB_JAR
        fi

        if [ -n "$_OLD_CLJENV_CLOJURE_JAVA_PATH" ] ; then
            CLOJURE_JAVA_PATH="$_OLD_CLJENV_CLOJURE_JAVA_PATH"
            export CLOJURE_JAVA_PATH
            unset _OLD_CLJENV_CLOJURE_JAVA_PATH
        fi

        if [ -n "$_OLD_CLJENV_CLOJURE_CLASSPATH" ] ; then
            CLOJURE_CLASSPATH="$_OLD_CLJENV_CLOJURE_CLASSPATH"
            export CLOJURE_CLASSPATH
            unset _OLD_CLJENV_CLOJURE_CLASSPATH
        fi

        if [ -n "$_OLD_CLJENV_CLOJURE_VM_ARGS" ] ; then
            CLOJURE_VM_ARGS="$_OLD_CLJENV_CLOJURE_VM_ARGS"
            export CLOJURE_VM_ARGS
            unset _OLD_CLJENV_CLOJURE_VM_ARGS
        fi

        if [ -n "$_OLD_CLJENV_CLOJURE_NATIVE_LIBRARY_PATH" ] ; then
            CLOJURE_NATIVE_LIBRARY_PATH="$_OLD_CLJENV_CLOJURE_NATIVE_LIBRARY_PATH"
            export CLOJURE_NATIVE_LIBRARY_PATH
            unset _OLD_CLJENV_CLOJURE_NATIVE_LIBRARY_PATH
        fi

        if [ -n "$_OLD_CLJENV_NAME" ] ; then
            CLJENV_NAME="$_OLD_CLJENV_NAME"
            export CLJENV_NAME
            unset _OLD_CLJENV_NAME
        fi

        if [ -n "$BASH" -o -n "$ZSH_VERSION" ] ; then
            hash -r
        fi

        if [ -n "$_OLD_CLJENV_PS1" ] ; then
            PS1="$_OLD_CLJENV_PS1"
            export PS1
            unset _OLD_CLJENV_PS1
        fi

        unset CLJENV
        if [ ! "$1" = "nondestructive" ] ; then
        # Self destruct!
            unset cljenv_deactivate

            if [ -n "$_CLJENV_AUTOSTART" ] ; then
                if [ ! "$_CLJENV_AUTOSTART" = "$CLJENV_FILE" ] ; then
                    echo 'Going back to autostart'
                    unset CLJENV_FILE
                    cljenv_autostart $_CLJENV_AUTOSTART $_CLJENV_AUTOSTART_NAME
                else
                    echo 'Unloading autostart'
                    unset _CLJENV_AUTOSTART_NAME
                    unset _CLJENV_AUTOSTART
                fi
            fi
        fi
    }

    cljenv_deactivate nondestructive
    _OLD_CLJENV_NAME="$CLJENV_NAME"
    _OLD_CLJENV_PATH="$PATH"

    if [ -z "$1" ]; then
        ENVFILE="`pwd`/.cljenv"
        CLJENV_NAME="`pwd`"
    elif [ -z "$2" ]; then
        ENVFILE="$1/.cljenv"
        CLJENV_NAME="$1"
    else
        ENVFILE=$1
        CLJENV_NAME="$2"
    fi

    export CLJENV_NAME

    if [ -f $ENVFILE ] ; then

        CLJENV_ROOT=$(dirname $ENVFILE)

        _OLD_CLJENV_CLOJURE_JAVA_PATH="$CLOJURE_JAVA_PATH"
        _OLD_CLJENV_CLOJURE_JAR="$CLOJURE_JAR"
        _OLD_CLJENV_CLOJURE_CONTRIB_JAR="$CLOJURE_CONTRIB_JAR"
        _OLD_CLJENV_CLOJURE_CLASSPATH="$CLOJURE_CLASSPATH"
        _OLD_CLJENV_CLOJURE_VM_ARGS="$CLOJURE_VM_ARGS"
        _OLD_CLJENV_CLOJURE_NATIVE_LIBRARY_PATH="$CLOJURE_NATIVE_LIBRARY_PATH"
        _OLD_CLJENV_FILE="$CLJENV_FILE"

        . $ENVFILE

        export CLJENV_FILE=$ENVFILE

        export CLOJURE_JAVA_PATH
        export CLOJURE_JAR
        export CLOJURE_CONTRIB_JAR
        export CLOJURE_CLASSPATH
        export CLOJURE_VM_ARGS
        export CLOJURE_NATIVE_LIBRARY_PATH
    else
        echo "ERROR: Cannot locate CLJENV definition at $ENVFILE"
        return 1
    fi

    export PATH="$CLJENV_HOME/bin:$PATH"

    if [ "$CLJENV_NAME" != "NOPS1" ] ; then
        _OLD_CLJENV_PS1="$PS1"
        if [ "`basename \"$CLJENV_NAME\"`" = "__" ] ; then
    # special case for Aspen magic directories
    # see http://www.zetadev.com/software/aspen/
            PS1="[`basename \`dirname \"$CLJENV_NAME\"\``] $PS1"
        else
            PS1="(`basename \"$CLJENV_NAME\"`)$PS1"
        fi
        export PS1
    fi

# This should detect bash and zsh, which have a hash command that must
# be called to get it to forget past commands.  Without forgetting
# past commands the $PATH changes we made may not be respected

    if [ -n "$BASH" -o -n "$ZSH_VERSION" ] ; then
        hash -r
    fi

    return 0
}

function cljenv_system() {
    cljenv_activate $SYSTEM_CLJENV_PATH system
}

function cljenv_user() {
    cljenv_activate $USER_CLJENV_PATH user
}

function cljenv_default() {
    cljenv_activate $DEFAULT_CLJENV_PATH default
}

function cljenv_autostart() {
    if [ "$1" == "NOPS1" ] ; then
        ENV_NAME="NOPS1"
    else
        ENV_NAME=`_cljenv_first_available_env_name`
    fi

    export _CLJENV_AUTOSTART=`_cljenv_path_for_create`
    export _CLJENV_AUTOSTART_NAME=$ENV_NAME

    cljenv_activate `_cljenv_path_for_create` $ENV_NAME
}

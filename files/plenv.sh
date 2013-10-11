# set PLENV_HOME
export PLENV_ROOT=$BOXEN_HOME/plenv

# set PATH
export PATH=$BOXEN_HOME/plenv/bin:$BOXEN_HOME/plenv/plugins/perl-build/bin:$PATH

# plenv init
eval "$(plenv init -)"


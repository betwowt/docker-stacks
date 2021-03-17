#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

wrapper=""
if [[ "${RESTARTABLE}" == "yes" ]]; then
    wrapper="run-one-constantly"
fi

if [[ ! -z "${JUPYTERHUB_API_TOKEN}" ]]; then
    # launched by JupyterHub, use single-user entrypoint
    exec /usr/local/bin/start-singleuser.sh "$@"
elif [[ ! -z "${JUPYTER_ENABLE_LAB}" ]]; then
    . /usr/local/bin/start.sh $wrapper jupyter lab "$@"
    echo -e "\nc.NotebookApp.token = ''\n" >> $HOME/.jupyter/jupyter_notebook_config.py
    if [[ ! -z "${BASE_URL}" ]]; then
        echo -e "c.NotebookApp.base_url = = '$BASE_URL'" >> $HOME/.jupyter/jupyter_notebook_config.py
    fi
else
    echo "WARN: Jupyter Notebook deprecation notice https://github.com/jupyter/docker-stacks#jupyter-notebook-deprecation-notice."
    . /usr/local/bin/start.sh $wrapper jupyter notebook "$@"
fi

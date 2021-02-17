FROM jupyter/base-notebook:ubuntu-18.04
RUN pip install jupyter-docx-bundler==0.3.2 --no-cache-dir -U
RUN jupyter bundlerextension enable --py jupyter_docx_bundler --sys-prefix

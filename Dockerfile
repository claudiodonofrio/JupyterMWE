FROM python:3.13-slim


# create a new user
RUN useradd --create-home --shell /bin/bash ffpy
RUN adduser ffpy sudo
USER ffpy
WORKDIR /home/ffpy

# install all dependencies
# remember COPY --chown=<user>:<group> <hostPath> <containerPath>

COPY --chown=ffpy:ffpy ./requirements.txt .
RUN python3 -m venv venv
RUN /home/ffpy/venv/bin/pip install -r requirements.txt

COPY ./plot_fp.ipynb .
USER root
RUN chmod 0755 /home/ffpy/plot_fp.ipynb
USER ffpy

RUN /home/ffpy/venv/bin/jupyter trust plot_fp.ipynb


EXPOSE 8000

CMD ["/home/ffpy/venv/bin/voila", "--no-browser",  "--port=8000", "/home/ffpy/plot_fp.ipynb"]

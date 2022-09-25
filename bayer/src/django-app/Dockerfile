FROM python:3.10.7-slim-bullseye


ENV PIP_DISABLE_PIP_VERSION_CHECK 1

RUN addgroup --system django \
    && adduser --system --ingroup django django

COPY ./requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt \
    && rm -rf /requirements.txt

COPY --chown=django:django ./app/ /app/

USER django
WORKDIR /app

ENTRYPOINT [ "/usr/local/bin/python" ]
CMD [ "manage.py","runserver", "0.0.0.0:8000" ]

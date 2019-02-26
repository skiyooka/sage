FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY sage.py requirements.txt ./

RUN ls -l

ENTRYPOINT [ "python", "./sage.py" ]
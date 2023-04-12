FROM python:3

WORKDIR /var/tmp

ADD ./icap_server.py /sbin/
ADD ./requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 1344/tcp
CMD ["python", "/sbin/icap_server.py"]

import socketserver
from pyicap import *

class ThreadingSimpleServer(socketserver.ThreadingMixIn, ICAPServer):
    pass

class ICAPHandler(BaseICAPRequestHandler):

    def echo_OPTIONS(self):
        self.set_icap_response(200)
        self.set_icap_header(b'Methods', b'RESPMOD')
        self.set_icap_header(b'Preview', b'0')
        self.send_headers(False)

    def echo_RESPMOD(self):
        self.set_icap_response(502)
        print("Response")
        self.send_headers(True)

port = 1344
server = ThreadingSimpleServer(('127.0.0.1', port), ICAPHandler)
try:
    while 1:
        server.handle_request()
except KeyboardInterrupt:
    print ("Finished")

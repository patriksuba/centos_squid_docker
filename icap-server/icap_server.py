import socketserver
from pyicap import *

class ThreadingSimpleServer(socketserver.ThreadingMixIn, ICAPServer):
    pass

class ICAPHandler(BaseICAPRequestHandler):

    def echo_OPTIONS(self):
        self.set_icap_response(200)
        self.set_icap_header(b'Methods', b'RESPMOD')
        self.set_icap_header(b'Service', b'PyICAP Server 1.0')
        self.set_icap_header(b'Preview', b'0')
        self.send_headers(False)

    def echo_RESPMOD(self):
        self.set_icap_response(200)
        print("Response")
        if b'system_id' in self.enc_res_headers[1]:
            self.set_enc_status(b'HTTP/1.1 502 Bad Gateway')
            self.set_enc_header(b'detail', b'System unauthorized')
            self.send_headers(True)
            return
            
        self.no_adaptation_required()

port = 1344
server = ThreadingSimpleServer(('127.0.0.1', port), ICAPHandler)
try:
    while 1:
        server.handle_request()
except KeyboardInterrupt:
    print ("Finished")

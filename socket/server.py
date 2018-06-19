import tornado.ioloop
import tornado.web
import tornado.websocket

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('index.html')

class ReSTHandler(tornado.websocket.WebSocketHandler):
    pressCount = {'count': 0}
    activeConnections = set()

    def open(self):
        self.activeConnections.add(self)
        print(self.activeConnections)
        self.write_message(str(self.pressCount['count']))

    def on_message(self, message):
        self.pressCount['count'] += 1
        for sock in self.activeConnections:
            sock.write_message(str(self.pressCount['count']))

class Server:
    def start_app(self):
        app = tornado.web.Application([
            (r"/", MainHandler),
            (r"/count", ReSTHandler)
        ])
        app.listen(8888)
        tornado.ioloop.IOLoop.current().start()

if __name__ == "__main__":
    server = Server()
    server.start_app()
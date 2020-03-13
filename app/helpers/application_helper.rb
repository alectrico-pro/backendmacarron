# Converted JsonWebToken from a Class to a Module to overcome error encountered in production logs on Heroku `heroku logs --tail` when a client calls the server API `500 Internal Server and NameError (uninitialized constant AuthenticateUser::JsonWebToken)`. Reference: http://disq.us/p/1a2ofln

#Si no se hace así, no se encuentra a la clases JsonWebToken que está declarada en lib
#Lo que ocurre aquí es que JsonWebToken es un módulo cuyoa métodos estarán disponibles con el helper de application
module ApplicationHelper
# include JsonWebToken 
end

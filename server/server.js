const restify = require('restify');
const Redis = require('ioredis');

const redis = new Redis({
  host: 'redis',
  port: 6379,
});

const server = restify.createServer();

// Root endpoint
server.get('/', (req, res, next) => {
    res.send({ message: 'Servidor está rodando!' });
    return next();
});

// Handle Redis connection errors
redis.on('error', (err) => {
    console.error('Erro na conexão com o Redis:', err);
    process.exit(1);
});

// Start the server
const PORT = process.env.PORT || 8082;
server.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});

//shutdown
process.on('SIGINT', () => {
    server.close(() => {
        console.log('Servidor fechado');
        redis.quit(); // Close the Redis connection
        process.exit();
    });
});

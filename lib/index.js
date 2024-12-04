const express = require('express'); // Importa Express para crear el servidor
const mysql = require('mysql'); // Importa MySQL para realizar consultas a la base de datos
const bodyParser = require('body-parser'); // Middleware para manejar JSON y datos en las peticiones
const bcrypt = require('bcryptjs'); // Importa bcryptjs para encriptar y comparar contraseñas
const crypto = require('crypto'); // Importa Crypto para generar tokens de recuperación de contraseña
const nodemailer = require('nodemailer'); // Importa Nodemailer para enviar correos electrónicos
const jwt = require('jsonwebtoken'); // Importa JWT para la autenticación basada en tokens
const secretKey = 'Super3quipo*'; // Clave secreta para firmar los tokens JWT (debe ser mantenida segura)

require('dotenv').config(); // Carga las variables de entorno desde un archivo .env
const cors = require('cors'); // Middleware para permitir solicitudes desde otros dominios (Cross-Origin Resource Sharing)

const app = express(); // Inicializa la aplicación de Express

// Habilita CORS para todas las rutas y usa body-parser para manejar JSON
app.use(cors());
app.use(bodyParser.json());

// Muestra las credenciales de Gmail cargadas desde las variables de entorno (para enviar correos)
console.log('GMAIL_USER:', process.env.GMAIL_USER);
console.log('GMAIL_PASS:', process.env.GMAIL_PASS);

// Configura una conexión con la base de datos MySQL usando un pool de conexiones
const pool = mysql.createPool({
  connectionLimit: 10, // Número máximo de conexiones simultáneas
  host: 'bdgaswise.cdcyk6yawygn.us-east-2.rds.amazonaws.com', // Host de la base de datos
  user: 'admin', // Usuario de la base de datos
  password: 'Super3quipo*', // Contraseña de la base de datos
  database: 'DBGasWise', // Nombre de la base de datos
  connectTimeout: 20000 // Tiempo de espera para conectarse (20 segundos)
});

// Inicia el servidor en el puerto 3000
app.listen(3000, () => {
  console.log('Servidor corriendo en el puerto 3000');
});

// Ruta para registrar un usuario con una contraseña encriptada
app.post('/register', async (req, res) => {
  const { nombre, email, contraseña } = req.body;

  // Verifica que se hayan proporcionado los datos obligatorios
  if (!nombre || !email || !contraseña) {
    return res.status(400).send('Faltan datos obligatorios');
  }

  try {
    // Encripta la contraseña con bcrypt antes de almacenarla
    const hashedPassword = await bcrypt.hash(contraseña, 10);

    // Inserta el usuario en la base de datos
    const query = 'INSERT INTO Usuario (Nombre, Email, Contraseña) VALUES (?, ?, ?)';
    pool.query(query, [nombre, email, hashedPassword], (err, result) => {
      if (err) {
        console.error('Error al insertar usuario:', err);
        return res.status(500).send('Error al registrar usuario');
      }
      res.send('Usuario registrado con éxito');
    });
  } catch (err) {
    console.error('Error al encriptar la contraseña:', err);
    res.status(500).send('Error interno al procesar la solicitud');
  }
});

// Ruta de inicio de sesión (login) con comparación de contraseñas encriptadas
app.post('/login', (req, res) => {
  const { email, password } = req.body;

  // Verifica que los campos de email y password no estén vacíos
  if (!email || !password) {
    return res.status(400).send('Faltan datos obligatorios');
  }

  // Consulta para obtener al usuario por email
  const query = 'SELECT * FROM Usuario WHERE Email = ?';
  pool.query(query, [email], async (err, result) => {
    if (err) {
      return res.status(500).send('Error al buscar usuario');
    }

    // Si el usuario no existe
    if (result.length === 0) {
      return res.status(401).send('Credenciales incorrectas');
    }

    const usuario = result[0];

    // Verifica si la contraseña almacenada existe
    if (!usuario.Contraseña) {
      return res.status(500).send('Error: No se encontró la contraseña en la base de datos.');
    }

    try {
      // Compara la contraseña ingresada con la contraseña encriptada en la base de datos
      const isMatch = await bcrypt.compare(password, usuario.Contraseña);
      console.log('Resultado de la comparación:', isMatch);

      // Si la contraseña no coincide
      if (!isMatch) {
        return res.status(401).send('Credenciales incorrectas');
      }

      // Si la contraseña coincide, genera un token JWT con el ID del usuario
      const token = jwt.sign({ id: usuario.UsuarioID }, secretKey, { expiresIn: '1h' });

      // Devuelve el token y el nombre del usuario como respuesta
      res.json({
        token: token,
        nombre: usuario.Nombre
      });
    } catch (err) {
      console.error('Error al comparar contraseñas:', err);
      return res.status(500).send('Error interno al procesar la solicitud.');
    }
  });
});

// Configura el transporte de Nodemailer para enviar correos electrónicos
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_USER, // Correo de Gmail (almacenado en variables de entorno)
    pass: process.env.GMAIL_PASS  // Contraseña del correo (almacenada en variables de entorno)
  }
});

// Ruta para solicitar la recuperación de contraseña
app.post('/solicitar-recuperacion', (req, res) => {
  const { email } = req.body;

  // Busca al usuario por su correo en la base de datos
  pool.query('SELECT * FROM Usuario WHERE Email = ?', [email], (err, result) => {
    if (err) {
      console.error('Error del servidor:', err);
      return res.status(500).send('Error del servidor');
    }

    // Si el usuario no existe
    if (result.length === 0) {
      console.log('No se encontró ninguna cuenta con este correo');
      return res.status(404).send('No se encontró ninguna cuenta con este correo');
    }

    // Genera un token aleatorio y establece la hora de expiración (1 hora)
    const token = crypto.randomBytes(20).toString('hex');
    const expiration = new Date();
    expiration.setHours(expiration.getHours() + 1);

    // Guarda el token y la expiración en la base de datos
    const query = 'UPDATE Usuario SET resetPasswordToken = ?, resetPasswordExpires = ? WHERE Email = ?';
    pool.query(query, [token, expiration, email], (err, result) => {
      if (err) {
        console.error('Error al guardar el token:', err);
        return res.status(500).send('Error al guardar el token');
      }

      // Envía un correo electrónico con el enlace para restablecer la contraseña
      const mailOptions = {
        from: process.env.GMAIL_USER,
        to: email,
        subject: 'Recuperación de Contraseña',
        text: `Has solicitado restablecer tu contraseña. Haz clic en el siguiente enlace para continuar:
        http://localhost:3000/reset-password/${token}`
      };

      transporter.sendMail(mailOptions, (err, info) => {
        if (err) {
          console.error('Error al enviar el correo:', err);
          return res.status(500).send('Error al enviar el correo');
        }

        console.log('Correo enviado con éxito:', info.response);
        res.send('Se ha enviado un correo con las instrucciones para restablecer la contraseña');
      });
    });
  });
});

// Ruta para restablecer la contraseña usando el token
app.post('/reset-password/:token', (req, res) => {
  const { token } = req.params;
  const { newPassword } = req.body;

  // Busca al usuario que coincida con el token y que el token no haya expirado
  const query = 'SELECT * FROM Usuario WHERE resetPasswordToken = ? AND resetPasswordExpires > NOW()';
  pool.query(query, [token], async (err, result) => {
    if (err) {
      return res.status(500).send('Error del servidor');
    }

    // Si el token no es válido o ya expiró
    if (result.length === 0) {
      return res.status(400).send('Token inválido o expirado');
    }

    const usuario = result[0];

    // Encripta la nueva contraseña
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Actualiza la contraseña del usuario y borra el token de recuperación
    const updateQuery = 'UPDATE Usuario SET Contraseña = ?, resetPasswordToken = NULL, resetPasswordExpires = NULL WHERE Email = ?';
    pool.query(updateQuery, [hashedPassword, usuario.Email], (err, result) => {
      if (err) {
        return res.status(500).send('Error al actualizar la contraseña');
      }

      res.send('Contraseña actualizada con éxito');
    });
  });
});

// Inicia otro servidor en el puerto 3001 (puedes eliminar esto si no lo necesitas)
app.listen(3001, () => {
  console.log('Servidor corriendo en el puerto 3001');
});

dotenv     = require 'dotenv-with-overload'
crypto     = require 'crypto'
nodemailer = require 'nodemailer'

forgot =
  create: (req, res) ->
    unless req.body.username and req.body.password
      return res.status(400).json 'message': 'username and password required'
    getUser req.body.username, req.body.password, (err, user) ->
      return res.status(400).json err if err
      return res.status(401).json 'message': 'invalid credentials' unless user
      token = generateToken user
      res.status(201).json {token, userID: user.user_id, username: user.username, firstName: user.first_name, lastName: user.last_name}

  requestReset: (req, res) ->
    unless req.body.email
      return res.status(400).json 'message': 'Email Address required'
    getUserByEmail req.body.email (err, user) ->
      return res.status(400).json err if err
      return res.status(401).json 'message': 'We could not find that email address in our records' unless user
      resetToken = generateResetToken
      link = req.headers.host
      sendForgotPasswordEmail(link, token, user)



  resetPassword: (req, res) ->



  getUserByEmail = (email, callback) ->
    pgClient.query
      text: 'SELECT * FROM users WHERE email = $1;',
      values: [email]
    , (err, result) ->
      return callback err if err
      callback null, result.rows[0]

  sendForgotPasswordEmail = (req, token, user) ->
    smptTransport = nodemailer.createTransport process.env.EMAIL_CONN,
    mailOptions = 
      from: 'Grapevine <grapevineFP@gmail.com>'
      to: user.email
      subject: 'Grapevine Password Reset'
      text: 'You are receiving this because you (or someone else) have requested the reset of the password for your account.\n\n' +
         'Please click on the following link, or paste this into your browser to complete the process:\n\n' +
         'http://' + req.headers.host + '/reset/' + token + '\n\n' +
         'If you did not request this, please ignore this email and your password will remain unchanged.\n''
    




module.exports = forgot
dotenv     = require 'dotenv-with-overload'
crypto     = require 'crypto'
nodemailer = require 'nodemailer'

forgot =

  requestReset = (req, res) ->
    unless req.body?.email
      return res.status(400).json 'message': 'Email Address required'
    getUserByEmail req.body.email (err, user) ->
      return res.status(400).json err if err
      return res.status(404).json 'message': 'We could not find that email address in our records' unless user
      generateResetToken (err, resetToken) ->
        return res.status(500).json err if err
        sendForgotPasswordEmail req, resetToken, user

  generateResetToken = (callback) ->
    crypto.randomBytes 20, (err, buf) ->
      token = buf.toString('hex')
      callback message: 'Password Reset Error Occured' if err
      callback null, token

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
         'If you did not request this, please ignore this email and your password will remain unchanged.\n'

  
reset = 

  requestResetPage(req, res) ->
    token = req.params.token
    getUserByResetToken token (err, user) ->
      return res.status(400).json err if err
      return res.status(404).json: 'Token invalid' unless user
      return res.status(200).


  getUserByResetToken = (token) ->
    pgClient.query
      text: 'SELECT * FROM users WHERE resetToken = $1',
      values: [token]
    , (err, result) ->
      return callback err if err
      callback null, result.rows[0]

  resetPassword: (req, res) -> 


module.exports = forgot
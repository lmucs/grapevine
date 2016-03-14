dotenv     = require 'dotenv-with-overload'
crypto     = require 'crypto'
nodemailer = require 'nodemailer'
mustache   = require 'mu2'

mustache.root = __dirname + '../../templates'
apiHost       = 'localhost'
passwordResetTimeoutMinutes = 5
grapevine_logoBase64 = 


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

  renderResetEmailTemplate = (user, callback) ->
    payload =
      name: user 
      expiresInMinutes: passwordResetTimeoutMinutes

    mustache.compileAndRender 'password_reset_email.html', payload

  sendForgotPasswordEmail = (req, token, user) ->
    smptTransport = nodemailer.createTransport process.env.EMAIL_CONN,
    resetUrl = "http://#{apiHost}/reset/#{token}"
    mailOptions = 
      from: 'Grapevine <grapevineFP@gmail.com>'
      to: user.email
      subject: 'Grapevine Password Reset'
      text: "You recently requested to reset your password for your Grapevine account. Copy and paste the link below into your browser window to reset it.\n\n
         #{resetUrl}\n\n
         If you did not request a password reset, please ignore this email and your account will remain unchanged. This password reset is only valid for the next #{passwordResetTimeoutMinutes} minutes.\n"
      html: renderResetEmailTemplate user, resetUrl
  
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
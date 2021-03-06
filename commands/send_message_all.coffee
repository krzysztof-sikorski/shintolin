_ = require 'underscore'
async = require 'async'
db = require '../db'

module.exports = (type, sender, recipients, blacklist = [], message = {}, cb) ->
  return cb() unless recipients.length and sender?
  unless _.isArray(blacklist)
    blacklist = [blacklist]

  now = new Date()
  tx = db.ObjectId()

  async.forEach recipients, (recipient, cb) ->
    blacklisted = _.some blacklist, (a) ->
      a?._id.toString() is recipient?._id.toString()
    if blacklisted or recipient.creature?
      cb()
    else
      m = _.extend
        type: type
        sender_name: sender?.name
        sender_id: sender?._id
        sender_slug: sender?.slug
        sent: now
        tx: tx
      , message
      m.recipient_id = recipient._id if recipient?
      db.chat_messages().insertOne m, cb
  , cb

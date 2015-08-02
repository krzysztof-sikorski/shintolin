moment = require 'moment'
db = require '../db'

module.exports = (settlement, cb) ->
  query =
    settlement_id: settlement._id
    last_action:
      $gt: moment().subtract(24, 'hours')._d
  db.characters.find(query).sort(name: 1).toArray cb

BPromise = require 'bluebird'
mw = require '../middleware'
charge_ap = BPromise.promisify(require '../../../commands/charge_ap')
last_action = {}
MIN_ACTION_GAP = 1500

module.exports = (app) ->
  app.post '/actions/:action_key', mw.available_actions(), (req, res, next) ->
    action = req.actions[req.params.action_key]
    BPromise.resolve()
      .then ->
        throw 'Invalid Action' unless action?.execute?
        throw 'You cannot do that while dazed.' if req.character.hp is 0 and not action.allow_while_dazed
        throw 'You don\'t have enough AP.' if action.ap? and req.character.ap < action.ap
      .then ->
        now = new Date().getTime()
        la = last_action[req.character.name]
        throw 'You must wait before taking another action.' if la and (now - la < MIN_ACTION_GAP)
        last_action[req.character.name] = now
      .then ->
        action.execute(req.body, req, res, next)
      .then ->
        charge_ap(req.character, action.ap) if action.ap? and action.charge_ap isnt false
      .then ->
        res.redirect '/game'
      .cancellable()
      .catch (err) ->
        if typeof err is 'string'
          next err
        else if err.message?
          next err.message
        else
          next err

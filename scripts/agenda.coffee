# Description:
#   Manages a Simple Agenda
#     useful to quickly add items that come up in chat
#     to an agenda to discuss at a future meeting.
#
# Dependencies:
#   hubot-redis-brain
#
# Configuration:
#   None
#
# Commands:
#   hubot agenda - Get the current agenda
#   hubot agenda add|add to agenda <item> - Adds an item to the agenda
#   hubot agenda delete|agenda remove|remove from agenda <item> - Removes an item from the agenda
#
# Author:
#   jprevost
#   based on: https://github.com/github/hubot-scripts/blob/master/src/scripts/grocery-list.coffee

module.exports = (robot) ->
  robot.brain.data.agenda =
    items: {}

  agenda =
    get: ->
      Object.keys(robot.brain.data.agenda.items)

    add: (item) ->
      robot.brain.data.agenda.items[item] = true

    remove: (item) ->
      delete robot.brain.data.agenda.items[item]
      true

  current_agenda = (msg) ->
    list = agenda.get().join("\n") || "No items in the agenda."
    msg.send "current agenda:\n" + "```" + list + "```"

  robot.respond /agenda(| list)$/i, (msg) ->
    current_agenda(msg)

  robot.respond /(add to agenda|agenda add) (.*)/i, (msg) ->
    item = msg.match[2].trim()
    agenda.add item
    msg.send "ok, added #{item} to the agenda."
    current_agenda(msg)

  robot.respond /(remove from agenda|agenda remove|agenda delete) (.*)/i, (msg) ->
    item = msg.match[2].trim()
    agenda.remove item
    msg.send "ok, removed #{item} from agenda (if it was there)."
    current_agenda(msg)

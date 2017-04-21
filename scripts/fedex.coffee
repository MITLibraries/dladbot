# Description:
#   Manages a Simple List of Items
#     used to manage a list of upcoming projects during
#     a FedEx ("shipit") day. This uses "fedex" because
#     "shipit" is already used for motivational squirrels.
#
# Dependencies:
#   hubot-redis-brain
#
# Configuration:
#   None
#
# Commands:
#   hubot fedex - Get the current list of projects
#   hubot fedex add|add to fedex <item> - Adds a project to the list
#   hubot fedex delete|fedex remove|remove from fedex <item> - Removes a project from the list
#
# Author:
#   matt-bernhardt
#   based on: https://github.com/github/hubot-scripts/blob/master/src/scripts/grocery-list.coffee

module.exports = (robot) ->
  robot.brain.data.fedex =
    items: {}

  fedex =
    get: ->
      Object.keys(robot.brain.data.fedex.items)

    add: (item) ->
      robot.brain.data.fedex.items[item] = true

    remove: (item) ->
      delete robot.brain.data.fedex.items[item]
      true

  current_fedex = (msg) ->
    list = fedex.get().join("\n") || "No items in the fedex list."
    msg.send "current fedex list:\n" + "```" + list + "```"

  robot.respond /fedex(| list)$/i, (msg) ->
    current_fedex(msg)

  robot.respond /(add to fedex|fedex add) (.*)/i, (msg) ->
    item = msg.match[2].trim()
    fedex.add item
    msg.send "ok, added #{item} to the fedex list."
    current_fedex(msg)

  robot.respond /(remove from fedex|fedex remove|fedex delete) (.*)/i, (msg) ->
    item = msg.match[2].trim()
    fedex.remove item
    msg.send "ok, removed #{item} from fedex list (if it was there)."
    current_fedex(msg)

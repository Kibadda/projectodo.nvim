describe("config", function()
  it("has default values after set()", function()
    local config = require "projectodo.config"

    config.set()

    assert.equal(vim.fn.stdpath "state" .. "/projectodo.log", config.options.log)
  end)

  it("has new values with custom config", function()
    local config = require "projectodo.config"

    local log = "~/other/log/location/name.log"

    config.set {
      log = log,
    }

    assert.equal(log, config.options.log)
  end)
end)

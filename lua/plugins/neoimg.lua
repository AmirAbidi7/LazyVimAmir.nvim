return {
  "skardyy/neo-img",
  build = ":NeoImg Install",
  lazy = true,
  config = function()
    require("neo-img").setup()
  end,
}

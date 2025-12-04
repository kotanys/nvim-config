return {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    tag = "v17.33.0",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        adapters = {
            http = {
                openai = function()
                    return require("codecompanion.adapters").extend("openai", {
                        opts = {
                            stream = true,
                        },
                        env = {
                            api_key = "cmd:cat ~/.credentials/openai-api"
                        },
                        schema = {
                            model = {
                                default = function()
                                    return "gpt-5"
                                end,
                            },
                        }
                    })
                end,
            }
        },
        strategies = {
            chat = {
                adapter = {
                    name = "openai",
                    model = "gpt-5",
                }
            },
            inline = {
                adapter = {
                    name = "openai",
                    model = "gpt-5",
                }
            }
        }
    }
}

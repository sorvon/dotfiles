-- lua/plugins/lsp-conf.lua
return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      capabilities = {
        workspace = {
          didChangeConfiguration = {
            dynamicRegistration = true,
          },
        },
      },
      servers = {
        lemminx = {
          settings = {
            xsl = {
              format = {
                enabled = true,
                insertSpaces = true,
              },
            },
            xslt = {
              format = {
                enabled = true,
                insertSpaces = true,
              },
            },
            xml = {
              format = {
                enabled = true,
                insertSpaces = true,
                maxLineWidth = 1000,
                splitAttributes = "preserve",
                preservedNewlines = 1,
                preserveAttributeLineBreaks = true,
                spaceBeforeEmptyCloseTag = true,
                formatComments = true,
                grammarAwareFormatting = true,
                preserveEmptyContent = true,
              },
              fileAssociations = {
                {
                  systemId = "/home/dyh/workspace/O45KZH-SECX/sec-server-gateway/o45-sec-common/src/main/resources/META-INF/t2_function.xsd",
                  pattern = "/home/dyh/workspace/O45KZH-SECX/sec-server-gateway/**/*.xml",
                },
              },
            },
          },
        },
      },
    },
  },
}

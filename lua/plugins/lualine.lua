return {
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            -- Drop the clock (far-right section). Line/column and progress
            -- stay in lualine_y.
            opts.sections.lualine_z = {}
        end,
    },
}

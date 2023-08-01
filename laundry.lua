LAUNDRY = {}

LAUNDRY.make_randomizer = function()
    local randomizer = {}
    randomizer.possible_articles = shallow_table_copy(LAUNDRY.ARTICLES)
    randomizer.possible_logos = shallow_table_copy(LAUNDRY.LOGO_SPRITES)
    randomizer.get_random_article = _laundry_get_random_article

    return randomizer
end

function _laundry_get_random_article(randomizer)
    -- refresh article pool if empty
    if #randomizer.possible_articles == 0 then
        randomizer.possible_articles = shallow_table_copy(LAUNDRY.ARTICLES)
    end

    -- pick random article from pool
    local article = {}
    article.meta = rnd(randomizer.possible_articles)
    del(randomizer.possible_articles, article.meta)

    -- random palette minimizing duplicates
    article.sprite = article.meta.sprite
    article.colors = {}
    for color_meta in all(article.meta.colors) do
        local palette_options = shallow_table_copy(color_meta.alt)
        for used_color in all(article.colors) do
            del(palette_options, used_color.color)
        end
        if #palette_options == 0 then
            palette_options = color_meta.alt
        end
        add(article.colors, { default = color_meta.default, color = rnd(palette_options) })
    end
    
    -- logo
    if article.meta.has_logo then
        -- refresh logo pool if empty
        if #randomizer.possible_logos == 0 then
            randomizer.possible_logos = shallow_table_copy(LAUNDRY.LOGO_SPRITES)
        end
        article.logo = rnd(randomizer.possible_logos)
        del(randomizer.possible_logos, article.logo)
    end

    -- article
    --  sprite  { name, id, x, y }
    --  colors  [ { default = c1, color = c2 }, ... ]
    --  logo    { name, id, x, y }
    return article
end

LAUNDRY.COLORS = {
    BLACK = 0,
    NAVY = 1,
    MAROON = 2,
    D_GREEN = 3,
    BROWN = 4,
    D_GRAY = 5,
    GRAY = 6,
    WHITE = 7,
    RED = 8,
    ORANGE = 9,
    YELLOW = 10,
    L_GREEN = 11,
    CYAN = 12,
    PURPLE = 13,
    PINK = 14,
    FLESH = 15
}

LAUNDRY.LOGO_SPRITES = {
    { name = "SMILE", id = 32, x = 0, y = 16 },
    { name = "RAINBOW", id = 33, x = 8, y = 16 },
    { name = "LOSS", id = 34, x = 16, y = 16 },
    { name = "WAVE", id = 35, x = 24, y = 16 },
    { name = "THUMB", id = 36, x = 32, y = 16 },
    { name = "CHERRY", id = 48, x = 0, y = 24 },
    { name = "FLOWER", id = 49, x = 8, y = 24 },
    { name = "BONER", id = 50, x = 16, y = 24 },
    { name = "STRAWB", id = 51, x = 24, y = 24 },
    { name = "BANAN", id = 52, x = 32, y = 24 }
}

LAUNDRY.ARTICLE_SPRITES = {
    TEE = { id = 0, x = 0, y = 0 },
    TIGHTY = { id = 1, x = 8, y = 0 },
    PANTS = { id = 2, x = 16, y = 0 },
    SOCKS = { id = 3, x = 24, y = 0 },
    SUMMER = { id = 4, x = 32, y = 0 },
    SKIRT = { id = 16, x = 0, y = 8 },
    STOCK = { id = 17, x = 8, y = 8 },
    JEANS = { id = 18, x = 16, y = 8 },
    OVERALLS = { id = 19, x = 24, y = 8 },
    RUFFLE = { id = 20, x = 32, y = 8 }
}

LAUNDRY.ARTICLES = {
    {
        sprite = LAUNDRY.ARTICLE_SPRITES.RUFFLE,
        has_logo = true,
        colors = {
            {
                default = LAUNDRY.COLORS.ORANGE,
                alt = {
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            },
            {
                default = LAUNDRY.COLORS.YELLOW,
                alt = {
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            }
        }
    },
    {
        sprite = LAUNDRY.ARTICLE_SPRITES.OVERALLS,
        has_logo = true,
        colors = {
            {
                default = LAUNDRY.COLORS.NAVY,
                alt = {
                    LAUNDRY.COLORS.BLACK,
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.D_GRAY,
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.PURPLE,
                }
            },
            {
                default = LAUNDRY.COLORS.PURPLE,
                alt = {
                    LAUNDRY.COLORS.BLACK,
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.D_GRAY,
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.PURPLE,
                }
            }
        }
    },
    {
        sprite = LAUNDRY.ARTICLE_SPRITES.JEANS,
        colors = {
            {
                default = LAUNDRY.COLORS.NAVY,
                alt = {
                    LAUNDRY.COLORS.BLACK,
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.D_GRAY,
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.PURPLE,
                }
            },
            {
                default = LAUNDRY.COLORS.PURPLE,
                alt = {
                    LAUNDRY.COLORS.BLACK,
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.D_GRAY,
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.PURPLE,
                }
            }
        }
    },
    {
        sprite = LAUNDRY.ARTICLE_SPRITES.STOCK,
        colors = {
            {
                default = LAUNDRY.COLORS.GRAY,
                alt = {
                    LAUNDRY.COLORS.BLACK,
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.D_GRAY,
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            },
            {
                default = LAUNDRY.COLORS.PURPLE,
                alt = {
                    LAUNDRY.COLORS.BLACK,
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.D_GRAY,
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            }
        }
    },
    {
        sprite = LAUNDRY.ARTICLE_SPRITES.SKIRT,
        has_logo = true,
        colors = {
            {
                default = LAUNDRY.COLORS.PINK,
                alt = {
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            },
            {
                default = LAUNDRY.COLORS.MAROON,
                alt = {
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            },
            {
                default = LAUNDRY.COLORS.ORANGE,
                alt = {
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            }
        }
    },
    {
        sprite = LAUNDRY.ARTICLE_SPRITES.SUMMER,
        colors = {
            {
                default = LAUNDRY.COLORS.PINK,
                alt = {
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            },
            {
                default = LAUNDRY.COLORS.MAROON,
                alt = {
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            }
        }
    },
    {
        sprite = LAUNDRY.ARTICLE_SPRITES.SOCKS,
        colors = {
            {
                default = LAUNDRY.COLORS.WHITE,
                alt = {
                    LAUNDRY.COLORS.BLACK,
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.D_GRAY,
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            },
            {
                default = LAUNDRY.COLORS.GRAY,
                alt = {
                    LAUNDRY.COLORS.BLACK,
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.D_GRAY,
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            }
        }
    },
    {
        sprite = LAUNDRY.ARTICLE_SPRITES.PANTS,
        colors = {
            {
                default = LAUNDRY.COLORS.ORANGE,
                alt = {
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            },
            {
                default = LAUNDRY.COLORS.BROWN,
                alt = {
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.D_GREEN,
                }
            },
            {
                default = LAUNDRY.COLORS.YELLOW,
                alt = {
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.WHITE,
                }
            }
        }
    },
    {
        sprite = LAUNDRY.ARTICLE_SPRITES.TIGHTY,
        colors = {
            {
                default = LAUNDRY.COLORS.WHITE,
                alt = {
                    LAUNDRY.COLORS.BLACK,
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.D_GRAY,
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            },
            {
                default = LAUNDRY.COLORS.GRAY,
                alt = {
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK,
                }
            }
        }
    },
    {
        sprite = LAUNDRY.ARTICLE_SPRITES.TEE,
        has_logo = true,
        colors = { 
            {
                default = LAUNDRY.COLORS.GRAY, 
                alt = {
                    LAUNDRY.COLORS.GRAY,
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.D_GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK
                }
            },
            { 
                default = LAUNDRY.COLORS.WHITE, 
                alt = {
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.BLACK,
                    LAUNDRY.COLORS.NAVY,
                    LAUNDRY.COLORS.MAROON,
                    LAUNDRY.COLORS.D_GREEN,
                    LAUNDRY.COLORS.BROWN,
                    LAUNDRY.COLORS.D_GRAY,
                    LAUNDRY.COLORS.WHITE,
                    LAUNDRY.COLORS.RED,
                    LAUNDRY.COLORS.ORANGE,
                    LAUNDRY.COLORS.YELLOW,
                    LAUNDRY.COLORS.L_GREEN,
                    LAUNDRY.COLORS.CYAN,
                    LAUNDRY.COLORS.PURPLE,
                    LAUNDRY.COLORS.PINK
                }
            } 
        }
    }
}
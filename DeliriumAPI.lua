script_author("sn1kers")
script_version("1.0.0")
script_url("")

local ffi = require "ffi"
local DAPI = {}

ffi.cdef[[
    struct CTextDrawData {
        float          m_fLetterWidth;
        float          m_fLetterHeight;
        unsigned long  m_letterColor;
        unsigned char  unknown;
        unsigned char  m_bCenter;
        unsigned char  m_bBox;
        float          m_fBoxSizeX;
        float          m_fBoxSizeY;
        unsigned long  m_boxColor;
        unsigned char  m_nProportional;
        unsigned long  m_backgroundColor;
        unsigned char  m_nShadow;
        unsigned char  m_nOutline;
        unsigned char  m_bLeft;
        unsigned char  m_bRight;
        int            m_nStyle;
        float          m_fX;
        float          m_fY;
        unsigned char  pad_[8];
        unsigned long  field_99B;
        unsigned long  field_99F;
        unsigned long  m_nIndex;
        unsigned char  field_9A7;
        unsigned short m_nModel;
        float          m_rotation[3];
        float          m_fZoom;
        unsigned short m_aColor[2];
        unsigned char  field_9BE;
        unsigned char  field_9BF;
        unsigned char  field_9C0;
        unsigned long  field_9C1;
        unsigned long  field_9C5;
        unsigned long  field_9C9;
        unsigned long  field_9CD;
        unsigned char  field_9D1;
        unsigned long  field_9D2;
    }__attribute__ ((packed));

    struct CTextDraw {
        char m_szText[801];
        char m_szString[1602];
        struct CTextDrawData m_data;
    }__attribute__ ((packed));

    struct CTextDrawPool {
        int       m_bNotEmpty[2048 + 256];
        struct CTextDraw* m_pObject[2048 + 256];
    }__attribute__ ((packed));
]]

local hud = {
    minValue = 535,
    maxValue = 605,

    visibility = 2056,
    radiation = 2055,
    hunger = 2054,
    health = 2057
}

local function getHUDValue(textdraw_id)
    local textdraw_pool = ffi.cast("struct CTextDrawPool*", sampGetTextdrawPoolPtr())
    local pObject = textdraw_pool.m_pObject[textdraw_id]

    if pObject ~= ffi.NULL then
        local sizeX = pObject.m_data.m_fBoxSizeX

        local normalized = ((sizeX - hud.minValue) / (hud.maxValue - hud.minValue)) * 100
        return math.max(0, math.min(normalized, 100)) -- ќграничиваем диапазон 0Ц100
    end

    return 0
end

DAPI.GetHUDHealth = function()
    return getHUDValue(hud.health)
end

DAPI.GetHUDVisibility = function()
    return getHUDValue(hud.visibility)
end

DAPI.GetHUDRadiation = function()
    return getHUDValue(hud.radiation)
end

DAPI.GetHUDHunger = function()
    return getHUDValue(hud.hunger)
end

return DAPI

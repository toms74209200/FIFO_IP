-- =====================================================================
--  Title       : Quartus FIFO IP
--
--  File Name   : FIFO_IP.vhd
--  Project     : 
--  Block       :
--  Tree        :
--  Designer    : toms74209200
--  Created	    : 2019/06/07
-- =====================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library altera_mf;
use altera_mf.all;

entity FIFO_IP is
    port(
    -- System --
        CLK         : in    std_logic;                          --(p) Clock
        nRST        : in    std_logic;                          --(n) Reset

    -- Control --
        WR          : in    std_logic;                          --(p) Data write
        RD          : in    std_logic;                          --(p) Data read
        EMPTY       : out   std_logic;                          --(p) FIFO empty
        FULL        : out   std_logic;                          --(p) FIFO full
        WDAT        : in    std_logic_vector(7 downto 0);       --(p) Write data
        RDAT        : out   std_logic_vector(7 downto 0)        --(p) Read data
        );
end FIFO_IP;

architecture RTL of FIFO_IP is

-- parameter --
constant device_family              : string := "MAX 10";
constant num_word                   : integer := 1024;

-- components --
component scfifo
GENERIC (
        add_ram_output_register     : STRING;
        intended_device_family      : STRING;
        lpm_numwords                : NATURAL;
        lpm_showahead               : STRING;
        lpm_type                    : STRING;
        lpm_width                   : NATURAL;
        lpm_widthu                  : NATURAL;
        overflow_checking           : STRING;
        underflow_checking          : STRING;
        use_eab                     : STRING
    );
    PORT (
            clock                   : IN STD_LOGIC ;
            data                    : IN STD_LOGIC_VECTOR (WDAT'range);
            rdreq                   : IN STD_LOGIC ;
            wrreq                   : IN STD_LOGIC ;
            empty                   : OUT STD_LOGIC ;
            full                    : OUT STD_LOGIC ;
            q                       : OUT STD_LOGIC_VECTOR (RDAT'range)
    );
    END COMPONENT;
begin

-- ***********************************************************
--	Access busy flag
-- ***********************************************************
U_SCFIFO : scfifo
GENERIC MAP (
    add_ram_output_register => "OFF",
    intended_device_family  => device_family,
    lpm_numwords            => num_word,
    lpm_showahead           => "ON",
    lpm_type                => "scfifo",
    lpm_width               => WDAT'length,
    lpm_widthu              => 10,
    overflow_checking       => "ON",
    underflow_checking      => "ON",
    use_eab                 => "ON"
)
PORT MAP (
    clock   => CLK,
    data    => WDAT,
    rdreq   => RD,
    wrreq   => WR,
    empty   => EMPTY,
    full    => FULL,
    q       => RDAT
);


end RTL;	-- FIFO_IP

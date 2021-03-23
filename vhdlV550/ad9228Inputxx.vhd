----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:48:25 01/12/2011 
-- Design Name: 
-- Module Name:    ad9228Input - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity ad9228Input is
  port (
    Clock : in std_logic;
    Reset : in std_logic;

    ADC_FC  : in std_logic;
    ADC_DC  : in std_logic;
    ADC_DCB : in std_logic;

    ClkDiv : in std_logic;

    ADC_DIn : in std_logic;

    ADC_Data : out std_logic_vector(11 downto 0)
    );
end ad9228Input;

architecture Behavioral of ad9228Input is

  signal q_temp    : std_logic_vector(5 downto 0);
  signal d_temp    : std_logic_vector(11 downto 0);
  signal iADC_Data : std_logic_vector(11 downto 0);

begin



-- ISERDES_NODELAY: Input SERial / DESerializer
-- Virtex-5
-- Xilinx HDL Libraries Guide, version 12.2
  ADC_SR_In : ISERDES_NODELAY
    generic map (
      BITSLIP_ENABLE => true,     -- TRUE/FALSE to enable bitslip controller
                            -- Must be "FALSE" in interface type is "MEMORY"
      DATA_RATE      => "DDR",          -- Specify data rate of "DDR" or "SDR"
      DATA_WIDTH     => 6,              -- Specify data width -
                              -- NETWORKING SDR: 2, 3, 4, 5, 6, 7, 8 : DDR 4, 6, 8, 10
                                    -- MEMORY SDR N/A : DDR 4
      INTERFACE_TYPE => "NETWORKING",   -- Use model - "MEMORY" or "NETWORKING"
      NUM_CE         => 1,  -- Define number or clock enables to an integer of 1 or 2
      SERDES_MODE    => "MASTER"  -- Set SERDES mode to "MASTER" or "SLAVE"
      )
    port map (
      Q1        => q_temp(0),           -- 1-bit registered SERDES output
      Q2        => q_temp(1),           -- 1-bit registered SERDES output
      Q3        => q_temp(2),           -- 1-bit registered SERDES output
      Q4        => q_temp(3),           -- 1-bit registered SERDES output
      Q5        => q_temp(4),           -- 1-bit registered SERDES output
      Q6        => q_temp(5),           -- 1-bit registered SERDES output
      SHIFTOUT1 => open,                -- 1-bit cascade Master/Slave output
      SHIFTOUT2 => open,                -- 1-bit cascade Master/Slave output
      BITSLIP   => '0',                 -- 1-bit Bitslip enable input
      CE1       => '1',                 -- 1-bit clock enable input
      CE2       => '0',                 -- 1-bit clock enable input
      CLK       => ADC_DC,              -- 1-bit master clock input
      CLKB      => ADC_DCB,  -- 1-bit secondary clock input for DATA_RATE=DDR
      CLKDIV    => ClkDiv,              -- 1-bit divided clock input
      D         => ADC_DIn,  -- 1-bit data input, connects to IODELAY or input buffer
      OCLK      => '0',
      RST       => Reset,               -- 1-bit asynchronous reset input
      SHIFTIN1  => '0',                 -- 1-bit cascade Master/Slave input
      SHIFTIN2  => '0'                  -- 1-bit cascade Master/Slave input
      );

  d_p : process(ClkDiv, reset)
  begin
    if (Reset = '1') then
      iADC_Data <= (others => '0');
    elsif (ClkDiv'event and clkdiv = '1') then
      iADC_Data(11 downto 6) <= iADC_Data(5 downto 0);
      iADC_Data(5 downto 0)  <= q_Temp;
    end if;
  end process;

  data_p : process(Clock, reset)
  begin
    if (Reset = '1') then
      ADC_Data <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      ADC_Data <= iADC_Data;
    end if;
  end process;

end Behavioral;


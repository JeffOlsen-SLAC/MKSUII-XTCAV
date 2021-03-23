-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      flash_intf.vhd - 
--
--      Copyright(c) SLAC 2000
--
--      Author: JEFF OLSEN
--      Created on: 3/24/2010 8:19:56 AM
--      Last change: JO 10/6/2011 10:14:40 AM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:27:10 03/09/2010 
-- Design Name: 
-- Module Name:    flash_intf - Behavioral 
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
use IEEE.std_logic_ARITH.all;
use IEEE.std_logic_UNSIGNED.all;


library work;
use work.mksuii.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flash_intf is
  port (
    Clock : in std_logic;
    Reset : in std_logic;

-- Link Interface                                                           
    Lnk_Addr      : in  std_logic_vector(15 downto 0);
    Lnk_DataIn    : in  std_logic_vector(15 downto 0);
    Lnk_WriteAddr : in  std_logic;
    Lnk_ReadBlk   : in  std_logic;
    Lnk_EraseBlk  : in  std_logic;
    Lnk_WriteBlk  : in  std_logic;
    Lnk_LockBlk   : in  std_logic;
    Lnk_DAV       : out std_logic;

    Reg_DataOut : out std_logic_vector(15 downto 0);

    Flash_We      : out std_logic;
    Flash_Oe      : out std_logic;
    Flash_Cs      : out std_logic;
    Flash_VPP     : out std_logic;
    Flash_AddrOut : out std_logic_vector(24 downto 0);
    Flash_DataIn  : in  std_logic_vector(15 downto 0);  -- From Flash Memory
    Flash_DataOut : out std_logic_vector(15 downto 0)   -- To Flash Memory

    );
end flash_intf;

architecture Behavioral of flash_intf is

  type flash_state_t is
    (
      Flash_Idle_s,
      Erase_StatusClr_s,
      UnLock_Setup_s,
      UnLock_Confirm_s,
      UnLock_Complete_s,
      Erase_Setup_s,
      Erase_Confirm_s,
      Erase_StatusWr_s,
      Erase_Delay_s,
      Erase_StatusRd_s,
      Erase_StatusTst_s,
      Erase_Flash_Wait_s,
      Erase_Done_s,
      Erase_Return_Header_s,
      Erase_Return_Status_s,
      Write_Fifo_s,
      Write_Setup_s,
      Write_Ready_Status_s,
      Write_Ready_s,
      Write_ReadyTst_s,
      Write_Count_s,
      Write_Rd_Fifo_s,
      Write_Flash_s,
      Write_Confirm_s,
      Write_Done_Status_s,
      Write_Done_s,
      Write_DoneTst_s,
      Read_Setup_s,
      Read_Flash_s,
      Read_LnkOut_Fifo_s,
      Write_LnkOut_Fifo_s,
      FWrite_s,
      FRead_s,
      Flash_ReadArray_En_s,
      Boot_s
      );


  signal Flash_State  : flash_state_t;
  signal Return_State : flash_state_t;

  signal CycleCntr  : std_logic_vector(7 downto 0);
  signal Cntr       : std_logic_vector(7 downto 0);
  signal BlkCntr    : std_logic_vector(11 downto 0);
  signal BlkAddr    : std_logic_vector(31 downto 0);
  signal iF_AddrOut : std_logic_vector(31 downto 0);
  signal iF_DataOut : std_logic_vector(15 downto 0);  -- To Flash Memory
  signal iFData     : std_logic_vector(15 downto 0);

  signal Flash_Wr_DPM : std_logic;

  signal Lnk_Ram_DataOut : std_logic_vector(15 downto 0);

  signal Lnk_Wr_Fifo      : std_logic;
  signal Flash_Fifo_Dout  : std_logic_vector(15 downto 0);
  signal Flash_Fifo_Rd    : std_logic;
  signal TimeoutWCntr     : std_logic_vector(27 downto 0);
  signal RFF_Reset        : std_logic;
  signal WFF_Reset        : std_logic;
  signal Rst_RFF          : std_logic;
  signal Rst_WFF          : std_logic;
  signal Flash_Cycle      : std_logic;
  signal iFlash_Status    : std_logic_vector(15 downto 0);
  signal Flash_Fifo_Empty : std_logic;
  signal iBlkAddr         : std_logic_vector(31 downto 0);
  signal Lnk_Read         : std_logic;
  signal LockData         : std_logic_vector(15 downto 0);  -- To Flash Memory


begin

  Flash_AddrOut <= iF_AddrOut(24 downto 0);
  Flash_DataOut <= iF_DataOut;
  Flash_VPP     <= '1';

  RFF_Reset <= Reset or Rst_RFF;
  WFF_Reset <= Reset or Rst_WFF;

  Read_p : process(Lnk_Read, iFlash_Status, Lnk_Ram_DataOut)
  begin
    if (Lnk_Read = '0') then
      Reg_DataOut <= iFlash_Status;
    else
      Reg_DataOut <= Lnk_Ram_DataOut;
    end if;

  end process;

  BlkAddr_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      BlkAddr <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      if (Lnk_WriteAddr = '1') then
        case Lnk_Addr is
          when x"0000" =>
            BlkAddr(15 downto 0) <= Lnk_DataIn;
          when x"0001" =>
            BlkAddr(31 downto 16) <= Lnk_DataIn;
          when others =>
        end case;
      end if;
    end if;
  end process;


  flash_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      Cntr          <= (others => '0');
      Flash_Cycle   <= '0';
      BlkCntr       <= (others => '0');
      Flash_We      <= '0';
      Flash_Oe      <= '0';
      Flash_Cs      <= '0';
      Rst_WFF       <= '0';
      Rst_RFF       <= '0';
      iFlash_Status <= (others => '0');
      LockData      <= (others => '0');
      Flash_Fifo_Rd <= '0';
      Flash_Wr_DPM  <= '0';
      Lnk_Wr_Fifo   <= '0';
      Lnk_DAV       <= '0';
      Lnk_Read      <= '0';
      iBlkAddr      <= (others => '0');
      iF_AddrOut    <= (others => '0');
      iF_DataOut    <= (others => '0');  -- To Flash Memory
      TimeoutWCntr  <= (others => '0');
      cyclecntr     <= (others => '0');
      ifdata        <= (others => '0');
      Flash_State   <= Flash_Idle_s;
    elsif (Clock'event and Clock = '1') then
      if (Rst_WFF = '1') then
        Rst_WFF <= '0';
      end if;

      if (Rst_RFF = '1') then
        Rst_RFF <= '0';
      end if;

      Flash_Fifo_Rd <= '0';

      case Flash_state is
        when Flash_Idle_s =>
          TimeoutWCntr <= (others => '0');
          Rst_WFF      <= '0';
          Rst_RFF      <= '0';
          Lnk_DAV      <= '0';
          Flash_Wr_DPM <= '0';
          iBlkAddr     <= BlkAddr;
          if (Lnk_EraseBlk = '1') then
            Lnk_Read      <= '0';
            iFlash_Status <= (others => '0');
            Flash_State   <= Erase_StatusClr_s;
          elsif (Lnk_LockBlk = '1') then
            LockData      <= Lnk_DataIn;
            Lnk_Read      <= '0';
            iFlash_Status <= (others => '0');
            Flash_State   <= Unlock_Setup_s;
          elsif (Flash_Fifo_Empty = '0') then
            Lnk_Read      <= '0';
            iFlash_Status <= (others => '0');
            Flash_Fifo_Rd <= '0';
            Flash_State   <= Write_Ready_Status_s;
          elsif (Lnk_ReadBlk = '1') then
            Lnk_Read    <= '1';
            Flash_State <= Read_Setup_s;
          else
            Flash_State <= Flash_Idle_s;
          end if;

        when Unlock_Setup_s =>
          iF_AddrOut   <= iBlkAddr;
          iF_DataOut   <= FUnlock_Setup;
          Return_State <= Unlock_Confirm_s;
          Flash_State  <= FWrite_s;

        when Unlock_Confirm_s =>
          iF_AddrOut   <= iBlkAddr;
          iF_DataOut   <= LockData;
          Return_State <= UnLock_Complete_s;
          Flash_State  <= FWrite_s;

        when UnLock_Complete_s =>
--              iF_AddrOut              <= iBlkAddr;
--              iF_DataOut              <= FRead_ArrayEn;
--              Return_State    <= Flash_Idle_s;
          Flash_State <= Flash_Idle_s;

        when Erase_StatusClr_s =>
          iF_AddrOut   <= x"00000000";
          iF_DataOut   <= FClear_Status;
          Return_State <= Erase_Setup_s;
          Flash_State  <= FWrite_s;

        when Erase_Setup_s =>
          iF_AddrOut   <= iBlkAddr;
          iF_DataOut   <= FErase_Setup;
          Return_State <= Erase_Confirm_s;
          Flash_State  <= FWrite_s;

        when Erase_Confirm_s =>
          iF_AddrOut   <= iBlkAddr;
          iF_DataOut   <= FErase_Confirm;
          Return_State <= Erase_Delay_s;
          Flash_State  <= FWrite_s;

        when Erase_Delay_s =>
          if (TimeoutWCntr = FlashEraseDelay1) then
            TimeoutWCntr <= (others => '0');
            Flash_State  <= Erase_StatusWr_s;
          else
            TimeoutWCntr <= TimeoutWCntr + 1;
            Flash_State  <= Erase_Delay_s;
          end if;


        when Erase_StatusWr_s =>
          iF_AddrOut   <= x"00000000";
          iF_DataOut   <= FRead_Status;
          Return_State <= Erase_StatusRd_s;
          Flash_State  <= FWrite_s;

        when Erase_StatusRd_s =>
          iF_AddrOut   <= x"00000000";
          Return_State <= Erase_StatusTst_s;
          Flash_State  <= FRead_s;

        when Erase_StatusTst_s =>
          TimeoutWCntr <= TimeoutWCntr + 1;
          if ((iFData and EraseBlkDone) = EraseBlkDone) then  -- Done set
            if ((iFData and EraseBlkErr) /= x"0000") then     -- Errors, quit
              iFlash_Status <= iFData;
              iF_AddrOut    <= x"00000000";            -- Clear Status
              iF_DataOut    <= FClear_Status;
              Return_State  <= Erase_Done_s;
              Flash_State   <= FWrite_s;
            else                        -- No Errors, quit
              iFlash_Status <= iFData;
              Flash_State   <= Erase_Done_s;
            end if;
          elsif (TimeoutWCntr = FlashEraseTOMax) then  -- Never Done, quit with TO
            iFlash_Status <= iFData or FlashEraseTO;
            iF_AddrOut    <= x"00000000";              -- Clear Status
            iF_DataOut    <= FClear_Status;
            Return_State  <= Erase_Done_s;
            Flash_State   <= FWrite_s;
          else                          -- Wait for ready
            iFlash_Status <= iFData;
            Flash_State   <= Erase_StatusWr_s;
          end if;

        when Erase_Done_s =>
          iFlash_Status <= iFlash_Status or FlashOpDone;
          Return_State  <= Flash_Idle_s;
          Flash_State   <= Flash_ReadArray_En_s;

        when Write_Ready_Status_s =>
          TimeoutWCntr <= TimeoutWCntr + 1;
          iF_AddrOut   <= iBlkAddr;
          iF_DataOut   <= FRead_Status;
          Return_State <= Write_Ready_s;
          Flash_State  <= FWrite_s;

        when Write_Ready_s =>
          iF_AddrOut   <= iBlkAddr;
          iF_DataOut   <= FRead_Status;
          Return_State <= Write_ReadyTst_s;
          Flash_State  <= FRead_s;

        when Write_ReadyTst_s =>
          if ((iFData and WriteBlkRdy) = WriteBlkRdy) then
            Flash_State <= Write_Setup_s;
          elsif (TimeoutWCntr = FlashWriteRdyTOMax) then  -- Never Done, quit with TO
            iFlash_Status <= IFData or FlashWriteRdyTO or FlashOpDone;
            Rst_WFF       <= '1';       -- Clear FIFO
            iF_AddrOut    <= x"00000000";                 -- Clear Status
            iF_DataOut    <= FClear_Status;
            Return_State  <= Flash_ReadArray_En_s;
            Flash_State   <= FWrite_s;
          else
            Flash_State <= Write_Ready_Status_s;
          end if;

        when Write_Setup_s =>
          Lnk_Wr_Fifo   <= '0';
          TimeoutWCntr  <= (others => '0');
          Flash_Fifo_Rd <= '0';
          iF_AddrOut    <= iBlkAddr;
          iF_DataOut    <= FWrite_Setup;
          Return_State  <= Write_Count_s;
          Flash_State   <= FWrite_s;

        when Write_Count_s =>
          iF_AddrOut    <= iBlkAddr;
          iF_DataOut    <= x"001F";
          Cntr          <= x"00";
          Flash_Fifo_Rd <= '1';
          Return_State  <= Write_Rd_Fifo_s;
          Flash_State   <= FWrite_s;

        when Write_Rd_Fifo_s =>
          if (Cntr = x"20") then
            Cntr        <= x"00";
            iBlkAddr    <= BlkAddr;
            Flash_State <= Write_Confirm_s;
          else
            Flash_Fifo_Rd <= '1';
            Flash_State   <= Write_Flash_s;
          end if;

        when Write_Flash_s =>
          Flash_Fifo_Rd <= '0';
          Cntr          <= Cntr + 1;
          iF_AddrOut    <= iBlkAddr;
          iBlkAddr      <= iBlkAddr + 1;
          iF_DataOut    <= Flash_Fifo_Dout;
          Return_State  <= Write_Rd_Fifo_s;
          Flash_State   <= FWrite_S;

        when Write_Confirm_s =>
          iF_AddrOut   <= iBlkAddr;
          iF_DataOut   <= FWrite_Confirm;
          Return_State <= Write_Done_Status_s;
          Flash_State  <= FWrite_s;

        when Write_Done_Status_s =>
          TimeoutWCntr <= TimeoutWCntr + 1;
          iF_AddrOut   <= iBlkAddr;
          iF_DataOut   <= FRead_Status;
          Return_State <= Write_Done_s;
          Flash_State  <= FWrite_s;

        when Write_Done_s =>
          iF_AddrOut   <= iBlkAddr;
          iF_DataOut   <= FRead_Status;
          Return_State <= Write_DoneTst_s;
          Flash_State  <= FRead_s;

        when Write_DoneTst_s =>
          if ((iFData and WriteBlkDone) = WriteBlkDone) then
            if (Flash_Fifo_Empty = '1') then              -- Done
              iFlash_Status <= IFData or FlashOpDone;
              iF_DataOut    <= FClear_Status;
              Return_State  <= Flash_ReadArray_En_s;
              Flash_State   <= FWrite_s;
            else
              Flash_State <= Write_Ready_Status_s;
            end if;
          elsif (TimeoutWCntr = FlashWriteRdyTOMax) then  -- Never Done, quit with TO
            iFlash_Status <= IFData or FlashWriteRdyTO or FlashOpDone;
            Rst_WFF       <= '1';       -- Clear FIFO
            iF_AddrOut    <= x"00000000";                 -- Clear Status
            iF_DataOut    <= FClear_Status;
            Return_State  <= Flash_ReadArray_En_s;
            Flash_State   <= FWrite_s;
          else
            Flash_State <= Write_Done_Status_s;
          end if;

        when Flash_ReadArray_En_s =>
          iF_AddrOut   <= x"00000000";  -- Enable Read Array
          iF_DataOut   <= FRead_ArrayEn;
          Return_State <= Flash_Idle_s;
          Flash_State  <= FWrite_s;

        when Read_Setup_s =>
          Rst_RFF      <= '1';
          iF_AddrOut   <= x"00000000";  -- Enable Read Array
          iF_DataOut   <= FRead_ArrayEn;
          BlkCntr      <= (others => '0');
          Return_State <= Read_Flash_s;
          Flash_State  <= FWrite_s;

        when Read_Flash_s =>
          Flash_Wr_DPM <= '0';
          iF_AddrOut   <= iBlkAddr;
          iBlkAddr     <= iBlkAddr + 1;
          Return_State <= Write_LnkOut_Fifo_s;
          Flash_State  <= FRead_s;

        when Write_LnkOut_Fifo_s =>
          Flash_Wr_DPM <= '1';
          if (BlkCntr = x"1FF") then
            LNK_Dav     <= '1';
            Flash_State <= Flash_Idle_s;
          else
            BlkCntr     <= BlkCntr +1;
            Flash_State <= Read_Flash_s;
          end if;

        when FWrite_s =>
          Flash_Oe <= '0';
          if (Flash_Cycle = '0') then
            CycleCntr   <= x"00";
            Flash_Cycle <= '1';
          else
            CycleCntr <= CycleCntr + 1;
          end if;
          if (CycleCntr = x"00") then
            Flash_WE    <= '1';
            Flash_Cs    <= '1';
            Flash_State <= Fwrite_s;
          elsif (CycleCntr = x"0D") then
            Flash_WE    <= '0';
            Flash_Cs    <= '0';
            Flash_State <= Fwrite_s;
          elsif (CycleCntr = x"20") then
            Flash_Cycle <= '0';
            Flash_State <= Return_State;
          end if;

        when FRead_s =>
          Flash_We <= '0';
          if (Flash_Cycle = '0') then
            CycleCntr   <= x"00";
            Flash_Cycle <= '1';
          else
            CycleCntr <= CycleCntr + 1;
          end if;
          if (CycleCntr = x"00") then
            Flash_OE    <= '1';
            Flash_Cs    <= '1';
            Flash_State <= FRead_s;
          elsif (CycleCntr = x"0D") then
            Flash_State <= FRead_s;
            iFData      <= Flash_DataIn;
          elsif (CycleCntr = x"0E") then
            Flash_OE    <= '0';
            Flash_Cs    <= '0';
            Flash_State <= FRead_s;
          elsif (CycleCntr = x"20") then
            Flash_Cycle <= '0';
            Flash_State <= Return_State;
          end if;

        when Boot_s =>
          Flash_State <= Flash_Idle_s;

        when others =>
          Flash_State <= Flash_Idle_s;

      end case;
    end if;
  end process;


  Fifo_WriteFifo : flash_fifo512x16     -- Data store from Lnk to Flash
    port map (
      rst   => WFF_Reset,
      clk   => Clock,
      din   => Lnk_DataIn,
      wr_en => Lnk_WriteBlk,
      dout  => Flash_Fifo_Dout,
      rd_en => Flash_Fifo_Rd,
      empty => Flash_Fifo_Empty,
      full  => open
      );

--Fifo_ReadFifo : flash_fifo512x16  -- Data store from Flash to Link
--port map (
--      rst             => RFF_Reset,
--      clk             => Clock,
--      din             => Flash_DataIn,
--      wr_en   => Flash_Wr_DPM,
--      dout            => Lnk_Ram_DataOut,
--      rd_en   => Lnk_ReadBlk,
--      empty   => open,
--      full            => open
--      );


  ReadRam : Flash_Fifo_DPRam512x15
    port map (
      clk  => clock,
      a    => iF_AddrOut(8 downto 0),
      d    => Flash_DataIn,
      we   => Flash_Wr_DPM,
      dpra => Lnk_Addr(8 downto 0),
      dpo  => Lnk_Ram_DataOut
      );

end Behavioral;


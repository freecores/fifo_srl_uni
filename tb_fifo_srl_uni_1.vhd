-------------------------------------------------------------------------------
-- Title      : Testbench for fifo_srl_uni.vhd
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tb_fifo_srl_uni_1.vhd
-- Author     : Tomasz Turek  <tomasz.turek@gmail.com>
-- Company    : SzuWar INC
-- Created    : 09:45:13 16-03-2010
-- Last update: 11:28:50 18-03-2010
-- Platform   : Xilinx ISE 10.1.03
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2010 SzuWar INC
-------------------------------------------------------------------------------
-- Revisions  :
-- Date                  Version  Author  Description
-- 09:45:13 16-03-2010   1.0      szuwarek  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity tb_fifo_srl_uni_1 is
   
end entity tb_fifo_srl_uni_1;

architecture testbench of tb_fifo_srl_uni_1 is

-------------------------------------------------------------------------------
-- Unit Under Test --
-------------------------------------------------------------------------------
   component fifo_srl_uni is
      
      generic (
            iDataWidth        : integer range 1 to 32   := 17;
            ififoWidth        : integer range 1 to 1023 := 33;
            iInputReg         : integer range 0 to 2    := 0;
            iOutputReg        : integer range 0 to 3    := 2;
            iFullFlagOfSet    : integer range 0 to 1021 := 2;
            iEmptyFlagOfSet   : integer range 0 to 1021 := 5;
            iSizeDelayCounter : integer range 5 to 11   := 6
            );

      port (
            CLK_I          : in  std_logic;
            DATA_I         : in  std_logic_vector(iDataWidth - 1 downto 0);
            DATA_O         : out std_logic_vector(iDataWidth - 1 downto 0);
            WRITE_ENABLE_I : in  std_logic;
            READ_ENABLE_I  : in  std_logic;
            READ_VALID_O   : out std_logic;
            FIFO_COUNT_O   : out std_logic_vector(iSizeDelayCounter - 1 downto 0);
            FULL_FLAG_O    : out std_logic;
            EMPTY_FLAG_O   : out std_logic
            );

   end component fifo_srl_uni;

-------------------------------------------------------------------------------
-- constants --
-------------------------------------------------------------------------------
   constant iDataWidth        : integer := 16;
   constant ififoWidth        : integer := 4;
   constant iInputReg         : integer := 0;
   constant iOutputReg        : integer := 1;
   constant iFullFlagOfSet    : integer := 1;
   constant iEmptyFlagOfSet   : integer := 1;
   constant iSizeDelayCounter : integer := 6;
   
   constant iWriteDataCounter : integer := 12;
   constant iReadDataCounter  : integer := 6;
   
-------------------------------------------------------------------------------
-- signals --
-------------------------------------------------------------------------------
   -- IN --
   signal CLK_I          : std_logic := '0';
   signal WRITE_ENABLE_I : std_logic := '0';
   signal READ_ENABLE_I  : std_logic := '0';
   signal DATA_I         : std_logic_vector(iDataWidth - 1 downto 0) := (others => '0');
   
   -- OUT --
   signal DATA_O       : std_logic_vector(iDataWidth - 1 downto 0);
   signal READ_VALID_O : std_logic;
   signal FULL_FLAG_O  : std_logic;
   signal EMPTY_FLAG_O : std_logic;
   signal FIFO_COUNT_O : std_logic_vector(iSizeDelayCounter - 1 downto 0);

   -- others --
   signal v_count       : std_logic_vector(15 downto 0) := x"0000";
   signal i_count_write : integer range 0 to ififoWidth := 0;
   
begin  -- architecture testbench


   UUT: fifo_srl_uni
      
      generic map (
            iDataWidth        => iDataWidth,
            ififoWidth        => ififoWidth,
            iInputReg         => iInputReg,
            iOutputReg        => iOutputReg,
            iFullFlagOfSet    => iFullFlagOfSet,
            iEmptyFlagOfSet   => iEmptyFlagOfSet,
            iSizeDelayCounter => iSizeDelayCounter
            )

      port map(
            CLK_I          => CLK_I,
            DATA_I         => DATA_I,
            DATA_O         => DATA_O,
            WRITE_ENABLE_I => WRITE_ENABLE_I,
            READ_ENABLE_I  => READ_ENABLE_I,
            READ_VALID_O   => READ_VALID_O,
            FIFO_COUNT_O   => FIFO_COUNT_O,
            FULL_FLAG_O    => FULL_FLAG_O,
            EMPTY_FLAG_O   => EMPTY_FLAG_O
            );

   StimulationProcess : process
      
   begin
      
      for i in 0 to 1000000 loop
         
         CLK_I <= not CLK_I;

         wait for 5 ns;

      end loop;

      wait;
      
   end process StimulationProcess;

   T0: process (CLK_I) is
   begin  -- process T0

      if rising_edge(CLK_I) then

         case v_count is

            when x"0003" =>

               DATA_I <= x"0010";
               WRITE_ENABLE_I <= '1';
               READ_ENABLE_I <= '0';
               v_count <= v_count + 1;               

            when x"0004" =>

               DATA_I <= x"0200";
               WRITE_ENABLE_I <= '1';
               READ_ENABLE_I <= '0';
               v_count <= v_count + 1;               

            when x"0005" =>

               DATA_I <= x"0100";
               WRITE_ENABLE_I <= '1';
               READ_ENABLE_I <= '0';
               v_count <= v_count + 1;
               
            when x"0006" =>

               DATA_I <= x"0000";
               WRITE_ENABLE_I <= '0';
               READ_ENABLE_I <= '0';
               v_count <= v_count + 1;

            when x"0007" =>

               DATA_I <= x"0000";
               WRITE_ENABLE_I <= '0';
               READ_ENABLE_I <= '1';
               v_count <= v_count + 1;

            when x"0008" =>

               DATA_I <= x"0000";
               WRITE_ENABLE_I <= '0';
               READ_ENABLE_I <= '0';
               v_count <= v_count + 1;
               
            when others =>

               WRITE_ENABLE_I <= WRITE_ENABLE_I;
               READ_ENABLE_I <= READ_ENABLE_I;
               v_count <= v_count + 1;
               
         end case;
         
      end if;
      
   end process T0;
   
end architecture testbench;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux3_32 is
	port(
		d0 : in  std_logic_vector(31 downto 0);
		d1 : in  std_logic_vector(31 downto 0);
		d2 : in  std_logic_vector(31 downto 0);
		s  : in  std_logic_vector(1 downto 0);
		y  : out std_logic_vector(31 downto 0)
	);
end entity mux3_32;

architecture RTL of mux3_32 is
begin
	with s select y <=
		d0 after 10 ns when "00",
		d1 after 10 ns when "01",
		d2 after 10 ns when "10",
		(others => 'X') after 10 ns when others;
end architecture RTL;

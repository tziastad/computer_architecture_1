library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eq_cmp is
	port(
		rA : in  std_logic_vector(31 downto 0);
		rB : in  std_logic_vector(31 downto 0);
		eq : out std_logic
	);
end entity eq_cmp;

architecture RTL of eq_cmp is
begin
	eq <= '1' after 10 ns when (rA = rB) else '0' after 10 ns;
end architecture RTL;

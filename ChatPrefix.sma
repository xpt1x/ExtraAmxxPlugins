#include <amxmodx>
#include <amxmisc>

#define OWNER(%0) (get_user_flags(%0) & ADMIN_RCON)
#define HEADMIN(%0) (get_user_flags(%0) & ADMIN_IMMUNITY)
#define ADMIN(%0) (get_user_flags(%0) & ADMIN_BAN)
#define VIP(%0) (get_user_flags(%0) & ADMIN_RESERVATION)

#define xOWNER "^1[^4OWNER^1]"
#define xHEADMIN "^1[^4HEAD ADMIN^1]"
#define xADMIN "^1[^4ADMIN^1]"
#define xVIP "^1[^4VIP^1]"

#define ALIVE(%0) is_user_alive(%0)

public plugin_init()
{
	register_plugin("Simple Chat Prefixes", "1.1 - BETA", "DiGiTaL")
	register_clcmd("say", "handleSay")
	register_clcmd("say_team", "handleTeamSay")
}

public handleSay(id) return checkMsg(id, false)
public handleTeamSay(id) return checkMsg(id, true)

public checkMsg(id, bool:teamSay)
{
	if(OWNER(id)) ALIVE(id) ? setMsg(id, true, xOWNER, true, teamSay) : setMsg(id, true, xOWNER, false, teamSay)
	else if(HEADMIN(id)) ALIVE(id) ? setMsg(id, true, xHEADMIN, true, teamSay) : setMsg(id, true, xHEADMIN, false, teamSay)
	else if(ADMIN(id)) ALIVE(id) ? setMsg(id, true, xADMIN, true, teamSay) : setMsg(id, true, xADMIN, false, teamSay)
	else if(VIP(id)) ALIVE(id) ? setMsg(id, true, xVIP, true, teamSay) : setMsg(id, true, xVIP, false, teamSay)
	else if(!is_user_admin(id)) ALIVE(id) ? setMsg(id, false, "", true, teamSay) : setMsg(id, false, "", false, teamSay)
	return PLUGIN_HANDLED
}

stock setMsg(index, bool:is_admin, type[], bool:is_alive, bool:is_teamSay)
{
	new nMsg[192],szArg[192], szName[32], szTeam[32], players[32], num
	get_user_name(index, szName, charsmax(szName))
	get_user_team(index, szTeam, charsmax(szTeam))

	read_args(szArg, charsmax(szArg))
	remove_quotes(szArg)

	if (!szArg[0] || szArg[0] == '/') return PLUGIN_HANDLED_MAIN

	if(is_alive)
	{
		if(is_teamSay)
		{
			is_admin ? formatex(nMsg, charsmax(nMsg), "^1(%s) %s ^3%s ^1: ^4%s", szTeam, type, szName, szArg) : formatex(nMsg, charsmax(nMsg), "^1(%s) ^3%s ^1: %s", szTeam, szName, szArg)
			get_players(players, num, "ae", szTeam)
			for(new i;i < num; i++) client_print_color(players[i], 0, nMsg)
		}
		else
		{
			(is_admin) ? formatex(nMsg, charsmax(nMsg), "%s ^3%s ^1: ^4%s", type, szName, szArg) : formatex(nMsg, charsmax(nMsg), "^3%s ^1: %s", szName, szArg)
			client_print_color(0, 0, nMsg)
		}
	} 
	else
	{
		if(is_teamSay)
		{
			(is_admin) ? formatex(nMsg, charsmax(nMsg), "^1*DEAD* (%s) %s ^3%s ^1: ^4%s", szTeam, type, szName, szArg) : formatex(nMsg, charsmax(nMsg), "^1*DEAD* (%s) ^3%s ^1: %s", szTeam, szName, szArg)
			get_players(players, num, "be", szTeam)
			for(new i;i < num; i++) client_print_color(players[i], 0, nMsg)
		}
		else 
		{
			(is_admin) ? formatex(nMsg, charsmax(nMsg), "^1*DEAD* %s ^3%s ^1: ^4%s", type, szName, szArg) : formatex(nMsg, charsmax(nMsg), "^1*DEAD* ^3%s ^1: %s", szName, szArg)
			get_players(players, num, "b")
			for(new i;i < num; i++) client_print_color(players[i], 0, nMsg)
		}
	} 
	return PLUGIN_HANDLED
}

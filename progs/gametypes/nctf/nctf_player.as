/*
Copyright (C) 2009-2010 Chasseur de bots

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

NPlayer[] gtPlayers( maxClients ); // gt info of each player

class NPlayer
{
    Client @client;
    Entity @ent;
    bool clicked = false;
    uint respawnTime;
	
    NPlayer()
    {
        // initialize all as grunt
        this.resetTimers();
    }

    ~NPlayer() {}

    void resetTimers()
    {
	    this.respawnTime = 0;
    }

    void checkRespawnQueue()
    {
        if ( this.respawnTime == 0 )
            return;

        if ( (this.respawnTime - 900) > levelTime )
        {
            int respawn = (( this.respawnTime - levelTime + 900 ) / 1000);
            if ( respawn > 0 )
                G_CenterPrintMsg( this.ent, "Respawning in " + respawn + " seconds" );
        }
        else
        {
            this.clicked = true;
            G_CenterPrintMsg( this.ent, "Click to respawn" );
            if (this.clicked || this.respawnTime + 3000 < levelTime || this.client.getBot() != null ){
                this.respawnTime = 0;
                this.client.respawn( false );
                this.clicked = false;
    			G_CenterPrintMsg( this.ent, "\n" );
            }
        }
    }
}

void NCTF_RespawnQueuedPlayers()
{
    for ( int i = 0; i < maxClients; i++ )
    {
        GetPlayer( i ).checkRespawnQueue();
    }
}

NPlayer @GetPlayer( Client @client )
{
    if ( @client == null )
        return null;

    if ( client.playerNum < 0 || client.playerNum >= maxClients )
        return null;

    return @gtPlayers[ client.playerNum ];
}

NPlayer @GetPlayer( int i )
{
    if ( i < 0 || i >= maxClients )
        return null;

    return @gtPlayers[ i ];
}

void InitPlayers()
{
    // autoassign to each object in the array it's equivalent client.
    for ( int i = 0; i < maxClients; i++ )
    {
        @gtPlayers[ i ].client = @G_GetClient( i );
        @gtPlayers[ i ].ent = @G_GetEntity( i + 1 );
    }
}

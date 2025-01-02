// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// Dummy Supabase and Cloudflare configurations
const SUPABASE_URL = 'https://dummy.supabase.co'
const CF_BASE_URL = 'https://api.cloudflare.com/client/v4/accounts/dummy_account'
const CF_AUTH_TOKEN = 'dummy_cloudflare_token'

serve(async (req: Request) => {
  try {
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'No authorization header' }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    const supabase = createClient(SUPABASE_URL, authHeader.replace('Bearer ', ''))

    const { data: expiredInvites, error: inviteError } = await supabase
      .from('invite')
      .select('projectId, imageUrl')
      .lt('deadline', new Date().toISOString())

    if (inviteError) {
      throw new Error(`Error fetching expired invites: ${inviteError.message}`)
    }

    if (!expiredInvites || expiredInvites.length === 0) {
      return new Response(JSON.stringify({ message: 'No expired invites found' }), {
        headers: { 'Content-Type': 'application/json' }
      })
    }

    const projectIds = expiredInvites.map(invite => invite.projectId)

    const { data: remoteRecords, error: remoteError } = await supabase
      .from('remote')
      .select('cloudflareID, projectId')
      .in('projectId', projectIds)

    if (remoteError) {
      throw new Error(`Error fetching remote records: ${remoteError.message}`)
    }

    for (const record of remoteRecords || []) {
      if (record.cloudflareID) {
        try {
          const response = await fetch(`${CF_BASE_URL}/stream/${record.cloudflareID}`, {
            method: 'DELETE',
            headers: {
              'Authorization': `Bearer ${CF_AUTH_TOKEN}`,
              'Content-Type': 'application/json'
            }
          })

          if (!response.ok) {
            console.error(`Failed to delete Cloudflare video ${record.cloudflareID}:`, await response.text())
          }
        } catch (error) {
          console.error(`Error deleting Cloudflare video ${record.cloudflareID}:`, error)
        }
      }
    }

    for (const invite of expiredInvites) {
      if (invite.imageUrl) {
        const path = invite.imageUrl.split('/').pop()
        if (path) {
          const { error: storageError } = await supabase.storage
            .from('images')
            .remove([path])

          if (storageError) {
            console.error(`Error deleting image ${path}:`, storageError)
          }
        }
      }
    }

    const { error: deleteRemoteError } = await supabase
      .from('remote')
      .delete()
      .in('projectId', projectIds)

    if (deleteRemoteError) {
      throw new Error(`Error deleting remote records: ${deleteRemoteError.message}`)
    }

    const { error: deleteInviteError } = await supabase
      .from('invite')
      .delete()
      .lt('deadline', new Date().toISOString())

    if (deleteInviteError) {
      throw new Error(`Error deleting invite records: ${deleteInviteError.message}`)
    }

    return new Response(JSON.stringify({
      message: 'Cleanup completed successfully',
      processed: {
        invites: expiredInvites.length,
        remoteRecords: remoteRecords?.length || 0
      }
    }), {
      headers: { 'Content-Type': 'application/json' }
    })

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
})

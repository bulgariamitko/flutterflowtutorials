export default {
    async fetch(request, env, ctx) {
        // Handle CORS
        if (request.method === 'OPTIONS') {
            return new Response(null, {
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'POST',
                    'Access-Control-Allow-Headers': 'Content-Type',
                },
            });
        }

        // Only handle POST requests for file upload
        if (request.method !== 'POST') {
            return new Response(JSON.stringify({ error: 'Method not allowed' }), {
                status: 405,
                headers: {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                },
            });
        }

        try {
            const formData = await request.formData();
            const file = formData.get('file');

            if (!file) {
                return new Response(JSON.stringify({ error: 'No file provided' }), {
                    status: 400,
                    headers: {
                        'Content-Type': 'application/json',
                        'Access-Control-Allow-Origin': '*',
                    },
                });
            }

            // Generate unique filename with original file extension
            const fileExtension = file.name ? `.${file.name.split('.').pop()}` : '';
            const uniqueName = `${Date.now()}-${Math.random().toString(36).substring(2, 15)}${fileExtension}`;

            // Upload to R2 using myBucket binding
            try {
                await env.myBucket.put(uniqueName, file.stream(), {
                    httpMetadata: {
                        contentType: file.type,
                    },
                });

                // Return success with file URL
                return new Response(
                    JSON.stringify({
                        success: true,
                        url: `https://YOUR_R2_BUCKET_URL/${uniqueName}`, // Replace with your R2 bucket URL
                        filename: uniqueName,
                        originalName: file.name,
                        type: file.type
                    }),
                    {
                        headers: {
                            'Content-Type': 'application/json',
                            'Access-Control-Allow-Origin': '*',
                        },
                    }
                );
            } catch (uploadError) {
                console.error('R2 upload error:', uploadError);
                return new Response(
                    JSON.stringify({
                        error: 'Storage upload failed',
                        details: uploadError.message
                    }),
                    {
                        status: 500,
                        headers: {
                            'Content-Type': 'application/json',
                            'Access-Control-Allow-Origin': '*',
                        },
                    }
                );
            }
        } catch (error) {
            console.error('Request processing error:', error);
            return new Response(
                JSON.stringify({
                    error: 'Request processing failed',
                    details: error.message
                }),
                {
                    status: 500,
                    headers: {
                        'Content-Type': 'application/json',
                        'Access-Control-Allow-Origin': '*',
                    },
                }
            );
        }
    },
};
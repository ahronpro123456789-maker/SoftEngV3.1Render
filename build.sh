#!/bin/bash

# IMPORTANT: Notice that EOF does NOT have quotes around it. 
# This is what allows your environment variables to be injected properly.
cat << EOF > UI.js
const _encoded = [
    // Groq Keys (Indices 0 to 6)
    '$GROQ_API_KEY_1', '$GROQ_API_KEY_2', '$GROQ_API_KEY_3', '$GROQ_API_KEY_4', 
    '$GROQ_API_KEY_5', '$GROQ_API_KEY_6', '$GROQ_API_KEY_7',
    
    // Supabase (Indices 7 & 8)
    '$SUPABASE_URL', '$SUPABASE_ANON_KEY',
    
    // EmailJS Login (Indices 9 to 14)
    '$EMAILJS_PUBLIC_KEY_LOGIN_1', '$EMAILJS_SERVICE_ID_LOGIN_1', '$EMAILJS_TEMPLATE_ID_LOGIN_1',
    '$EMAILJS_PUBLIC_KEY_LOGIN_2', '$EMAILJS_SERVICE_ID_LOGIN_2', '$EMAILJS_TEMPLATE_ID_LOGIN_2',
    
    // EmailJS Signup (Indices 15 to 20)
    '$EMAILJS_PUBLIC_KEY_SIGNUP_1', '$EMAILJS_SERVICE_ID_SIGNUP_1', '$EMAILJS_TEMPLATE_ID_SIGNUP_1',
    '$EMAILJS_PUBLIC_KEY_SIGNUP_2', '$EMAILJS_SERVICE_ID_SIGNUP_2', '$EMAILJS_TEMPLATE_ID_SIGNUP_2',
    
    // EmailJS Upload (Indices 21 to 26)
    '$EMAILJS_PUBLIC_KEY_UPLOAD_1', '$EMAILJS_SERVICE_ID_UPLOAD_1', '$EMAILJS_TEMPLATE_ID_UPLOAD_1',
    '$EMAILJS_PUBLIC_KEY_UPLOAD_2', '$EMAILJS_SERVICE_ID_UPLOAD_2', '$EMAILJS_TEMPLATE_ID_UPLOAD_2'
];

// Helper to decode Base64 and instantly strip invisible newlines/spaces
const dec = (val) => {
    try { return val ? atob(val).trim() : ''; } 
    catch (e) { return ''; }
};

window.API_KEYS = {
    SUPABASE_URL: dec(_encoded[7]),
    SUPABASE_ANON_KEY: dec(_encoded[8]),
    
    // 7 Groq Keys
    GROQ: { 
        pool: [
            dec(_encoded[0]), dec(_encoded[1]), dec(_encoded[2]), 
            dec(_encoded[3]), dec(_encoded[4]), dec(_encoded[5]), 
            dec(_encoded[6])
        ], 
        index: 0 
    },
    EMAIL_LOGIN: {
        pool: [
            { PK: dec(_encoded[9]), SID: dec(_encoded[10]), TID: dec(_encoded[11]) },
            { PK: dec(_encoded[12]), SID: dec(_encoded[13]), TID: dec(_encoded[14]) }
        ], index: 0
    },
    EMAIL_SIGNUP: {
        pool: [
            { PK: dec(_encoded[15]), SID: dec(_encoded[16]), TID: dec(_encoded[17]) },
            { PK: dec(_encoded[18]), SID: dec(_encoded[19]), TID: dec(_encoded[20]) }
        ], index: 0
    },
    EMAIL_UPLOAD: {
        pool: [
            { PK: dec(_encoded[21]), SID: dec(_encoded[22]), TID: dec(_encoded[23]) },
            { PK: dec(_encoded[24]), SID: dec(_encoded[25]), TID: dec(_encoded[26]) }
        ], index: 0
    }
};

window.API_HELPERS = {
    getGroqKey: () => window.API_KEYS.GROQ.pool[window.API_KEYS.GROQ.index],
    rotateGroqKey: () => {
        window.API_KEYS.GROQ.index = (window.API_KEYS.GROQ.index + 1) % window.API_KEYS.GROQ.pool.length;
        console.warn(\`🔄 Rotated Groq API Key to #\${window.API_KEYS.GROQ.index + 1}\`);
    },
    getEmailConfig: (type) => window.API_KEYS['EMAIL_' + type].pool[window.API_KEYS['EMAIL_' + type].index],
    rotateEmailConfig: (type) => {
        const configStr = 'EMAIL_' + type;
        window.API_KEYS[configStr].index = (window.API_KEYS[configStr].index + 1) % window.API_KEYS[configStr].pool.length;
        console.warn(\`🔄 Rotated EmailJS \${type} Key.\`);
        emailjs.init(window.API_HELPERS.getEmailConfig(type).PK);
    }
};
EOF

echo "✅ UI.js successfully generated with atob AND trim!"

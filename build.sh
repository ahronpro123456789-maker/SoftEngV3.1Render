#!/bin/bash

# Generates UI.js with environment variables injected
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

window.API_KEYS = {
    SUPABASE_URL: atob(_encoded[7]),
    SUPABASE_ANON_KEY: atob(_encoded[8]),
    
    GROQ: { 
        pool: [
            atob(_encoded[0]), atob(_encoded[1]), atob(_encoded[2]), 
            atob(_encoded[3]), atob(_encoded[4]), atob(_encoded[5]), 
            atob(_encoded[6])
        ], 
        index: 0 
    },
    EMAIL_LOGIN: {
        pool: [
            { PK: atob(_encoded[9]), SID: atob(_encoded[10]), TID: atob(_encoded[11]) },
            { PK: atob(_encoded[12]), SID: atob(_encoded[13]), TID: atob(_encoded[14]) }
        ], index: 0
    },
    EMAIL_SIGNUP: {
        pool: [
            { PK: atob(_encoded[15]), SID: atob(_encoded[16]), TID: atob(_encoded[17]) },
            { PK: atob(_encoded[18]), SID: atob(_encoded[19]), TID: atob(_encoded[20]) }
        ], index: 0
    },
    EMAIL_UPLOAD: {
        pool: [
            { PK: atob(_encoded[21]), SID: atob(_encoded[22]), TID: atob(_encoded[23]) },
            { PK: atob(_encoded[24]), SID: atob(_encoded[25]), TID: atob(_encoded[26]) }
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

echo "✅ UI.js successfully generated!"

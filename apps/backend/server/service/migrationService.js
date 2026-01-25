const db = require('../infra/database');
const fs = require('fs');
const path = require('path');

const MAX_RETRIES = 10;
const RETRY_DELAY_MS = 2000;

async function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

exports.runMigrations = async function () {
    let retries = 0;
    while (retries < MAX_RETRIES) {
        try {
            console.log(`[Migration] Attempting to connect to DB (Try ${retries + 1}/${MAX_RETRIES})...`);
            
            // Test connection
            await db.connect();
            console.log('[Migration] DB Connection successful.');

            // Read SQL file
            // Note: Adjust path assuming migration.js is in server/infra/ and create.sql is in database/
            // Root is apps/backend. server/infra is apps/backend/server/infra. 
            // So ../../database/create.sql
            const sqlPath = path.join(__dirname, '../../database/create.sql');
            
            if (!fs.existsSync(sqlPath)) {
                 console.warn(`[Migration] Warning: create.sql not found at ${sqlPath}. Skipping.`);
                 return;
            }

            const sql = fs.readFileSync(sqlPath, 'utf8');
            
            console.log('[Migration] Applying schema...');
            await db.none(sql);
            console.log('[Migration] Schema applied successfully.');
            return; // Success

        } catch (error) {
            console.error(`[Migration] Error: ${error.message}`);
            retries++;
            if (retries >= MAX_RETRIES) {
                console.error('[Migration] Max retries reached. Exiting.');
                process.exit(1);
            }
            await sleep(RETRY_DELAY_MS);
        }
    }
};

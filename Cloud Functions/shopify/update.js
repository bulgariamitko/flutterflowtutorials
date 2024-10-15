// gadget import

import { applyParams, save, ActionOptions, UpdateShopifyOrderActionContext } from "gadget-server";
import { preventCrossShopDataAccess } from "gadget-server/shopify";

/**
 * @param { UpdateShopifyOrderActionContext } context
 */
export async function run({ params, record, logger, api, connections }) {
    applyParams(params, record);
    await preventCrossShopDataAccess(params, record);
    await save(record);
};

/**
 * @param { UpdateShopifyOrderActionContext } context
 */
export async function onSuccess({ params, record, logger, api, connections }) {
    try {
        // Log the original Shopify webhook payload
        console.log('Original ORDER Shopify webhook params:', JSON.stringify(params, null, 2));

        // Send the original Shopify webhook payload to Firebase Cloud Function
        const response = await fetch(
            'https://PROJECT.cloudfunctions.net/handleShopifyWebhook',
            {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(params),
            }
        );

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const responseText = await response.text();
        logger.info('Webhook sent successfully', { status: response.status, response: responseText });
    } catch (error) {
        logger.error('Error sending webhook', { error: error.message });
    }
};

/** @type { ActionOptions } */
export const options = { actionType: "update" };

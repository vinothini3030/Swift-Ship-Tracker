# SwiftShip Tracker – Salesforce CLI deployment

Builds everything from the SwiftShip Tracker spec that can be deployed as metadata, with no manual clicking:

| Spec item | Deployed as |
|---|---|
| Custom objects Parcel, Delivery, Sender, Receiver (reports, search, history on) | `objects/*` |
| All fields and lookups from the field tables (Parcel ID auto number `P-{000}`, Status picklist, Weight, Estimated Delivery Date, geolocation fields, emails, contacts) | `objects/*/fields/*` |
| Custom tabs (Milestone 3) | `tabs/*` |
| "SwiftShip Tracker" Lightning app | `applications/SwiftShip_Tracker` |
| Flow "Parcel Details" (auto-launched, input `ids`, output `Output`) | `flows/Parcel_Details` |
| Permission set "Swift Ship" (objects, fields, tabs, app, flow) | `permissionsets/Swift_Ship` |
| Sample data | `scripts/apex/seed.apex` |

Field API names were tidied from the spec's typos: `Sender_Address__c`, `Sender_Contact__c`, `Receiver_Address__c`, and so on.

## 1. Install the tools (once)
```
node -v                                # need Node 18+
npm install -g @salesforce/cli
sf --version
```

## 2. Deploy – the quick way
Unzip, open a terminal in the `SwiftShipTracker` folder, then run:

- Windows: `deploy.cmd`
- macOS/Linux: `./deploy.sh`

## 3. Deploy – the same thing, command by command
```
sf org login web --alias swiftship --set-default
sf project deploy start --source-dir force-app --target-org swiftship --wait 30
sf org assign permset --name Swift_Ship --target-org swiftship
sf apex run --file scripts/apex/seed.apex --target-org swiftship
sf org open --target-org swiftship
```
Optional dry run before deploying: `sf project deploy validate --source-dir force-app --target-org swiftship`

Open the App Launcher, choose SwiftShip Tracker, and you'll see 3 sample parcels (P-001, P-002, P-003, assuming a fresh org).

## 4. Agentforce part (enable in the org, then wire up the agent)
Agents and prompt templates depend on org features and licenses, so these steps stay in Setup. The Flow they need is already deployed.

1. Setup → Einstein Setup → turn on Einstein, then Agentforce Agents → turn on Agentforce and the default agent.
2. Open the default agent in Agentforce Builder → Topics/Subagent → Actions → New Agent Action → type **Flow** → reference flow **Parcel Details**. Map input `ids` (Parcel ID) and output `Output`.
3. Rename the agent to SwiftShip Tracker → Save → Activate.
4. The agent user needs the Einstein Agent license plus permission set `Swift_Ship`. Assign it under Setup → Users → Einstein Agent user → Permission Set Assignments.
5. Test in the preview: "Track parcel P-001".

The spec's separate Prompt Builder template ("Retrieve Parcel Details") is optional here because the flow already builds the tracking summary itself (name, ID, status, weight, estimated delivery date).

## Not included (add later)
Email alerts and templates, Batch Apex, reports and dashboards, Experience Cloud site, and profiles or role hierarchy. Ask if you want these generated as metadata too.

## Troubleshooting
- `Parcel_ID__c ... permission` error: deploy the whole `force-app` folder, not a single file, so the order resolves.
- Tabs require a `<motif>` (already included as `Custom9: Gears`). If Salesforce rejects it, pick any valid icon value.
- Flow not visible to the agent: re-run `sf org assign permset --name Swift_Ship` for the agent user, or check Flow access.

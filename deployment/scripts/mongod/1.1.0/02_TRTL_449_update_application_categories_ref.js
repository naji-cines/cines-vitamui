db = db.getSiblingDB('iam')

print("Start 06_TRTL_449_update_application_categories_ref.js");

db.applications.update({
    "identifier" : "ACCOUNTS_APP",
    "category": "users",
}, {
    $set: {
        "category": "ingest_and_consultation"
    },
});

db.applications.update({
    "identifier" : "PROFILES_APP",
    "category": "settings",
}, {
    $set: {
        "category": "organization_and_user_rights"
    },
});

db.applications.update({
    "identifier" : "USERS_APP",
    "category": "administrators",
}, {
    $set: {
        "category": "organization_and_user_rights"
    },
});

db.applications.update({
    "identifier" : "GROUPS_APP",
    "category": "settings",
}, {
    $set: {
        "category": "organization_and_user_rights"
    },
});

db.applications.update({
    "identifier" : "CUSTOMERS_APP",
    "category": "settings",
}, {
    $set: {
        "category": "organization_and_user_rights"
    },
});

db.applications.update({
    "identifier" : "SUBROGATIONS_APP",
    "category": "administrators",
}, {
    $set: {
        "category": "organization_and_user_rights"
    },
});


db.applications.update({
    "identifier" : "HIERARCHY_PROFILE_APP",
    "category": "settings",
}, {
    $set: {
        "category": "organization_and_user_rights"
    },
});

db.applications.update({
    "identifier": "AUDIT_APP",
    "category": "opaudit",
}, {
    $set: {
        "category": "ingest_and_consultation"
    },
});

db.applications.update({
    "identifier": "PROBATIVE_VALUE_APP",
    "category": "opaudit",
}, {
    $set: {
        "category": "ingest_and_consultation"
    },
});

db.applications.update({
    "identifier": "SECURE_APP",
    "category": "opaudit",
}, {
    $set: {
        "category": "ingest_and_consultation"
    },
});

db.applications.update({
    "identifier": "DSL_APP",
    "category": "techadmin",
}, {
    $set: {
        "category": "ingest_and_consultation"
    },
});

print("End 06_TRTL_449_uate_application_categories_ref.js");

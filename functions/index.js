const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const moment = require("moment-timezone");

admin.initializeApp();

exports.sendDailyTaskReminder = functions.pubsub.schedule('0 * * * *')
    .onRun(async (context) => {
        const nowUTC = moment().utc();
        console.log(`UTC: ${nowUTC.format()}`);

        const userSnapshot = await admin.firestore().collection('users')
            .where('isNotificationsEnabled', '==', true)
            .get();

        const promises = [];

        userSnapshot.forEach((doc) => {
            const data = doc.data();
            const fcmToken = data.fcmToken;
            const timezone = data.timezone;

            if (!fcmToken || !timezone) return;

            const localTime = moment().tz(timezone);
            const currentHour = localTime.hour();

            if (currentHour !== 9) return;

            const startOfDay = localTime.clone().startOf('day').toDate();
            const endOfDay = localTime.clone().endOf('day').toDate();

            console.log(`User ${doc.id} - Timezone: ${timezone}!`);

            const taskPromise = admin.firestore()
                .collection('users')
                .doc(doc.id)
                .collection('tasks')
                .where('dueDateTime', '>=', startOfDay)
                .where('dueDateTime', '<=', endOfDay)
                .where('completed', '==', false)
                .get()
                .then(async (taskSnapshot) => {
                    const count = taskSnapshot.size;
                    if (count === 0) {
                        console.log(`No tasks due today for user ${doc.id}!`);
                        return null;
                    }

                    console.log(`${count} tasks due today for user ${doc.id}!`);

                    const payload = {
                        token: fcmToken,
                        notification: {
                            title: 'Daily Task Reminder',
                            body: `You have ${count} tasks due today!`,
                        },
                        data: {
                            route: '/upcoming',
                            click_action: 'FLUTTER_NOTIFICATION_CLICK',
                        }
                    };
                    try {
                        const response = await admin.messaging().send(payload);
                        console.log(`Success! Response: ${response}`);
                    } catch (err){
                        console.error(`Error sending message: ${doc.id}:`, err);
                        if (err.code === 'messaging/registration-token-not-registered'
                            || err.code === 'messaging/invalid-argument') {
                                console.log('Token is no longer valid!');
                                await admin.firestore()
                                    .collection('users')
                                    .doc(doc.id)
                                    .update({
                                        fcmToken: admin.firestore.FieldValue.delete()
                                    });
                        }
                    }
                })
                .catch((err) => {
                    console.error(`Error checking tasks for user ${doc.id}:`, err);
                });

            promises.push(taskPromise);
            });
            return Promise.all(promises);
        });
# my_chat_app

1. Chat List Screen
2. Individual Chat Screen
3. Message Bubbles
4. Input Field & Action Bar
5. User Status Indicator
6. Timestamp & Read Receipts
7. Typing Indicator:
8. Scroll to Bottom
9. Sticky Header:

10. 



## ============Learn (_initSocket)================
* ১. প্রথমে Socket কানেক্ট করো: WebSocketChannel.connect দিয়ে সার্ভারের সাথে ডিজিটাল পাইপলাইন তৈরি করা।

* ২. পরিচয় দাও (Join): সার্ভারকে জানানো কোন ইউজার জয়েন করছে, যাতে একজনের মেসেজ ভুল করে আরেকজনের কাছে চলে না যায়।

* ৩. শুনতে থাকো (Listen): stream.listen দিয়ে সারাক্ষণ কান পেতে থাকা যে সার্ভার থেকে কোনো নতুন মেসেজ বা পরিবর্তন আসছে কি না।

* ৪. ডাটা আসলে মডেল বানাও: সকেট থেকে আসা জটিল ডাটাকে MessageModel-এ সাজিয়ে নেওয়া, কারণ মডেল না বানালে অ্যাপ ডাটাগুলো পড়তে বা চিনতে পারবে না।

* ৫. স্টেট আপডেট করে ইউজারকে দেখাও: রিভারপড স্টেট আপডেট করা যাতে মেসেজটি স্ক্রিনে ভেসে ওঠে এবং ইউজার দেখতে পায়।

### কানেক্ট হও → পরিচয় দাও → শুনতে থাকো → মডেল বানাও → স্টেট আপডেট করো।
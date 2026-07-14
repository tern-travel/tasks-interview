# This file seeds the database with a starting set of users and tasks. Load it
# with `bin/rails db:seed` (or alongside db:create via `bin/rails db:setup`).
#
# All accounts share the password "abc123" so any of them can be used to log in.

[
  "Ada Lovelace",
  "Grace Hopper",
  "Katherine Johnson",
  "Alan Turing",
  "Edsger Dijkstra"
].each_with_index do |name, index|
  User.where(email: "user#{index + 1}@tern.travel").first_or_create!(
    name: name,
    password: "abc123",
    password_confirmation: "abc123"
  )
end

# Titles intentionally vary in casing, length, and shared substrings (several
# "Book ...", two "... client ...") so filtering and sorting have something real
# to chew on. A few descriptions are left blank to exercise the index view's
# nil-safe truncation.
tasks = [
  {title: "Book flights to Lisbon", complete: true, description: "Outbound May 3, return May 17. Aisle seats for both legs."},
  {title: "Book hotel in Kyoto", complete: false, description: "Ryokan near Gion, 4 nights, breakfast included."},
  {title: "Book airport transfer", complete: false, description: nil},
  {title: "Confirm client itinerary", complete: false, description: "Send the day-by-day plan to the Hendricks party for sign-off."},
  {title: "Email client welcome packet", complete: true, description: "Visa reminders, packing list, emergency contacts."},
  {title: "Renew passport", complete: false, description: "Expedited — current one expires in under six months."},
  {title: "Update travel insurance", complete: false, description: nil},
  {title: "Draft Q3 trip budget", complete: false, description: "Roll up supplier quotes and a 12% contingency."},
  {title: "Review supplier contracts", complete: true, description: "Check cancellation windows before the deposit deadline."},
  {title: "Schedule team offsite", complete: false, description: "Two days, somewhere reachable by train for everyone."},
  {title: "Reconcile expense report", complete: false, description: "March card statement against the receipts folder."},
  {title: "Plan Patagonia route", complete: false, description: "El Chaltén to Torres del Paine, padding for weather days."},
  {title: "Order currency for Japan", complete: false, description: nil},
  {title: "Sync with ground operator", complete: true, description: "Confirm the driver and guide for the Marrakech leg."},
  {title: "Archive old itineraries", complete: false, description: "Anything from last season can move to cold storage."},
  {title: "follow up with Lisbon hotel", complete: false, description: "Lowercase on purpose — still waiting on the room upgrade."}
]

tasks.each do |attributes|
  Task.where(title: attributes[:title]).first_or_create!(attributes.except(:title))
end

# By default only the curated tasks above are seeded. Set SEED_TASK_COUNT to
# top the table up to a larger backlog when you need volume.
target_count = ENV.fetch("SEED_TASK_COUNT", 16).to_i

if Task.count < target_count
  now = Time.current
  verbs = %w[Book Confirm Email Review Draft Plan Order Sync Archive Update Reconcile Schedule Cancel Rebook Invoice]
  destinations = %w[Lisbon Kyoto Marrakech Patagonia Reykjavik Hanoi Cusco Porto Split Tbilisi Oaxaca Lagos]
  nouns = ["itinerary", "hotel block", "flight change", "transfer", "deposit", "welcome packet", "visa", "insurance", "budget", "supplier contract"]

  rows = Array.new(target_count - Task.count) do
    title = "#{verbs.sample} #{destinations.sample} #{nouns.sample}"
    title = title.downcase if rand < 0.1

    {
      title: title,
      complete: rand < 0.4,
      description: (Faker::Lorem.sentence(word_count: rand(4..10)) if rand < 0.7),
      created_at: now,
      updated_at: now
    }
  end

  rows.each_slice(1_000) { |slice| Task.insert_all(slice) }
end

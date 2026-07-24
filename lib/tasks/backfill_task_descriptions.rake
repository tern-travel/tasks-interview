namespace :tasks do
  desc "Split legacy \"Title: Description\" titles into a clean title + description"
  task backfill_descriptions: :environment do
    scope = Task.where(description: [nil, ""]).where("title LIKE ?", "%:%")
    puts "Backfilling #{scope.count} legacy task(s)..."

    updated = 0
    scope.find_each do |task|
      title, description = task.title.split(":", 2)
      next if description.blank?

      task.update!(title: title.strip, description: description.strip)
      updated += 1
    end

    puts "Done. Split #{updated} task title(s) into title + description."
  end
end

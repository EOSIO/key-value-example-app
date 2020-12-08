#include <kv_todo.hpp>

[[eosio::action]]
std::vector<todo_entry> kv_todo::getbyaccname(name account_name) {
   std::vector<todo_entry> entries;

   for (const auto& entry : todo_entries ) {
      if (entry.second().get_account_name() == account_name) {
         entries.push_back(entry.second());
      }
   }

   return entries;
}

[[eosio::action]]
todo_entry kv_todo::upsert(const std::string& uuid,
                           eosio::name account_name,
                           const std::string& task,
                           bool checked) {

   require_auth(account_name);

   auto itr = todo_entries.find(uuid);
   if (itr != todo_entries.end()) {
      todo_entry entry = itr->second();
      check(account_name == entry.get_account_name(), "Unauthorized");
      todo_entries[uuid] = todo_entry{uuid, entry.get_account_name(), task, checked, entry.get_created()};
   } else {
      uint32_t created = eosio::current_time_point().sec_since_epoch();
      todo_entries[uuid] = todo_entry{uuid, account_name, task, checked, created};
   }

   return todo_entries[uuid];
}

[[eosio::action]]
void kv_todo::del(const std::string& uuid) {
   auto itr = todo_entries.find(uuid);

   if (itr != todo_entries.end()) {
      todo_entries.erase(uuid);
      eosio::print_f("todo_entry was successfully deleted from table.");
   } else {
      eosio::print_f("todo_entry not found in table.");
   }
}

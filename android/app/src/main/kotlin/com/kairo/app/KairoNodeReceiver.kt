package com.kairo.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import java.io.File
import java.io.FileWriter
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class KairoNodeReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "com.kairo.app.ACTION_LOG_EXPENSE") {
            val amount = intent.getDoubleExtra("amount", 0.0)
            val category = intent.getStringExtra("category") ?: "expense"
            
            if (amount > 0) {
                try {
                    val file = File(context.filesDir, "kairo_node_expenses.csv")
                    val isNew = !file.exists()
                    val writer = FileWriter(file, true)
                    
                    if (isNew) {
                        writer.append("date,type,amount\n")
                    }
                    
                    val dateStr = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(Date())
                    writer.append("\$dateStr,\$category,\$amount\n")
                    writer.flush()
                    writer.close()
                    
                    Log.d("KairoNode", "Logged expense to node file: \$amount")
                } catch (e: Exception) {
                    Log.e("KairoNode", "Error logging expense", e)
                }
            }
        }
    }
}

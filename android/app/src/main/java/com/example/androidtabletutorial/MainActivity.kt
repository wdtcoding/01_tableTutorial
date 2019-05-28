package com.example.androidtabletutorial

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.support.v7.widget.LinearLayoutManager
import com.android.volley.Request
import com.android.volley.RequestQueue
import com.android.volley.Response
import com.android.volley.toolbox.JsonArrayRequest
import com.android.volley.toolbox.Volley
import kotlinx.android.synthetic.main.activity_main.*
import org.json.JSONArray

class MainActivity : AppCompatActivity() {

    private val url = "https://api.github.com/users?since=0"
    private var queue: RequestQueue? = null
    private var resultSet: JSONArray? = null

    private lateinit var linearLayoutManager: LinearLayoutManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        //The Volley queue should be put in a singleton, but we'll do that in the next tutorial
        this.queue = Volley.newRequestQueue(this)

        linearLayoutManager = LinearLayoutManager(this)
        recyclerView.layoutManager = linearLayoutManager

        //created a button here just so you can use to debug if you wish
        reloadButton.setOnClickListener {
            this.downloadData()
        }

        this.downloadData()
    }

    private fun downloadData() {

        println("Download Button Pressed")

        //You can specify StringRequest, JsonObjectRequest or JsonArrayRequest
        //Here is a StringRequest one you can use, taken from the official Android documentation

//        val request = StringRequest(Request.Method.GET, url, Response.Listener<String> { response ->
//            //println("Response is: ${response.substring(0, 500)})"
//        }, Response.ErrorListener { error ->
//            println(error.toString()) })

        val request = JsonArrayRequest(Request.Method.GET, url, null, Response.Listener { response ->

            //no need to be extra with defining our model in this tutorial.
            //we'll just directly use the JSON response as our map and pass that in
            this.resultSet = response
            recyclerView.adapter = resultSet?.let { UserInfoAdapater(it, this) }
        }, Response.ErrorListener { error ->
            println(error.toString()) })

        this.queue?.add(request)
    }
}

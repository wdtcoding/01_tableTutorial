package com.example.androidtabletutorial

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import kotlinx.android.synthetic.main.item_row.view.*
import org.json.JSONArray
import android.graphics.Bitmap
import com.android.volley.toolbox.ImageRequest
import com.android.volley.Response
import android.widget.ImageView
import com.android.volley.RequestQueue
import com.android.volley.toolbox.Volley


class UserInfoAdapater (val items : JSONArray, val context: Context) : RecyclerView.Adapter<ViewHolder>() {

    private var queue: RequestQueue? = null

    override fun onCreateViewHolder(p0: ViewGroup, p1: Int): ViewHolder {
        this.queue = Volley.newRequestQueue(context)
        return ViewHolder(LayoutInflater.from(context).inflate(R.layout.item_row, p0, false))
    }

    override fun getItemCount(): Int {
        return items.length()
    }

    override fun onBindViewHolder(p0: ViewHolder, p1: Int) {

        //Set the name field accordingly, and then use the avatar_url to get the image
        //This is not the most optimal way to get the image, just a way to illustrate
        //that it can be done with Volley

        var currentItem = items.getJSONObject(p1)
        p0.nameTextView?.text = currentItem?.getString("login")
        p0.avatarImageView.setImageResource(android.R.color.transparent)

        val request = ImageRequest(
            currentItem.getString("avatar_url"),
            Response.Listener<Bitmap> { response: Bitmap? ->
                p0.avatarImageView?.setImageBitmap(response)
            }, 300, 300, ImageView.ScaleType.CENTER, Bitmap.Config.RGB_565, null)

        this.queue?.add(request)
    }
}

class ViewHolder (view: View) : RecyclerView.ViewHolder(view) {
    //View is very simple, just has an imageview and a textview
    val nameTextView = view.nameTextView
    val avatarImageView = view.avatarImageView
}
